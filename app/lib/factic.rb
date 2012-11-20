class Factic
  def initialize(repository, options)
    @repository = repository
    @options = options
    @facets = Facets.new(options[:facets])
    @options[:per_page] ||= 20
  end

  def search(params)
    params[:page] = params[:page].to_i if params[:page] =~ /[0-9]+/ # TODO move out
    search_params = extract_sanitized_params(params)
    search = create_search(params)
    response = @repository.search(search.to_query)
    populate_results(response, params, search_params)
  end

  def quickfacet(facet_name, params)
    sanitized_params = extract_sanitized_params(params)
    search = @facets.create_quickfacet_search(facet_name, params)
    response = @repository.search(search.to_query)
    populate_quickfacet_results(facet_name, response, sanitized_params)
  end

  def populate_quickfacet_results(facet_name, response, search_params)
    results = Results.new
    results.hits = response.hits
    results.took = response.took
    results.search_params = search_params
    @facets.populate_quickfacet(facet_name, results, search_params, response)
  end

  def extract_facets_params(params)
    @facets.extract_sanitized_params(params)
  end

  def create_restrictions_search(params)
    @facets.create_search(extract_facets_params(params)) # TODO refactor
  end

  private
  def extract_sanitized_params(params)
    sanitized_params = extract_facets_params(params)
    add_sanitized_sort_params(params, sanitized_params)
    add_sanitized_pagination_params(params, sanitized_params)
    sanitized_params
  end

  def extract_sanitized_params_for_quickfacet(facet_name, params)
    sanitized_params = extract_facets_params(params)
    @facets.add_quickfacet_params(facet_name, params, sanitized_params)
    sanitized_params
  end

  def add_sanitized_sort_params(params, sanitized_params)
    field = params[:sort]
    return unless field.present?
    sanitized_params[:sort] = field if sortable_field?(field)
  end

  def add_sanitized_pagination_params(params, sanitized_params)
    return unless params[:page].present?
    sanitized_params[:page] = params[:page] if params[:page] =~ /[0-9]+/
  end

  def sortable_field?(field)
    @options[:sort_fields].include?(field.to_sym)
  end

  def create_search(params)
    search = @facets.create_search(params)
    search.fields = @options[:fields]
    search.highlight = @options[:highlight]
    sort_order = params[:sort_order] ? params[:sort_order] : :desc
    search.sort << {params[:sort] => {:order => sort_order}} if params[:sort]
    search.from = (params[:page] - 1) * @options[:per_page] if params[:page]
    search.size = @options[:per_page]
    search
  end

  def populate_results(response, params, sanitized_params)
    results = Results.new
    results.hits = response.hits
    results.took = response.took
    results.search_params = params
    results.per_page = @options[:per_page]
    results.offset = @options[:per_page] * ((params[:page] || 1) - 1) + 1
    @facets.populate(results, sanitized_params, response)
    results
  end

  class Facets
    include Enumerable

    def initialize(facets)
      @facets = {}.with_indifferent_access
      facets.each do |facet|
        @facets[facet.name] = facet
      end
    end

    def extract_sanitized_params(params)
      sanitized_params = {}
      each { |facet| facet.try(:add_sanitized_params, params, sanitized_params) if facet.respond_to?(:add_sanitized_params) }
      sanitized_params
    end

    def add_quickfacet_params(facet_name, params, sanitized_params)
      @facets[facet_name].add_quickfacet_params(params, sanitized_params)
    end

    def create_search(params)
      search = Search.new
      each { |facet| facet.try(:add_restrictions, params, search) if facet.respond_to?(:add_restrictions) }
      each { |facet| facet.try(:add_facet_definition, params, search) if facet.respond_to?(:add_facet_definition) }
      search
    end

    def create_quickfacet_search(facet_name, params)
      facet = @facets[facet_name]
      search = Search.new
      each { |f| f.try(:add_restrictions, params, search) if f.respond_to?(:add_restrictions) }
      facet.try(:quicksearch, params, search) if facet.respond_to?(:quicksearch)
      search
    end

    def populate(results, params, response)
      each { |facet| facet.populate(results, params, response) }
    end

    def populate_quickfacet(facet_name, results, params, response)
      facet = @facets[facet_name]
      facet.populate(results, params, response)
      results.facets[facet_name]
    end

    def each(&block)
      @facets.each_value { |facet| yield(facet) }
    end
  end

  public
  class Search
    attr_accessor :query, :filters, :facets, :fields, :sort, :scoring_function, :highlight, :from, :size

    def initialize
      @query = nil
      @filters = []
      @facets = {}
      @fields = []
      @sort = []
      @highlight = {}
      @scoring_function = nil
      @from = 0
      @size = 10
    end

    def to_query
      build_query
    end

    def to_scrollable
      scrollable = self.class.new
      scrollable.query = @query
      scrollable.filters = @filters
      scrollable.fields = [:_id]
      # TODO scroll type
      scrollable
    end

    def build_query
      search = @filters.any? ? build_filtered_query : build_simple_query
      search[:facets] = @facets if @facets.any?
      search[:fields] = @fields if @fields.any?
      search[:highlight] = {:fields => @highlight} if @highlight.any?
      search[:sort] = @sort if @sort.any?
      search[:from] = @from
      search[:size] = @size
      search
    end

    private
    def build_simple_query
      query = {}
      if @scoring_function
        query[:query] = {:custom_score => {
            :query => @query || {:match_all => {}},
            :script => @scoring_function
        }
        }
      else
        query[:query] = @query || {:match_all => {}}
      end
      query[:filter] = {:and => @filters} if @filters.any?
      query
    end

    def build_filtered_query
      {:query => {:filtered => build_simple_query}}
    end
  end

  class Results
    attr_accessor :hits, :took, :facets, :search_params, :per_page, :offset

    def initialize
      @facets = {}.with_indifferent_access
    end

    def current_page
      search_params[:page] || 1
    end

    def num_pages
      (hits.total.to_f / per_page).ceil
    end
    alias :total_pages :num_pages

    def limit_value
      per_page
    end
  end
end

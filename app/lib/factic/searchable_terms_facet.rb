class Factic
  class SearchableTermsFacet < Facet

    def initialize(field, options = {})
      super(field, options)
      @param_name = options[:param_name] || field
      @missing_param_value = options[:missing_param_value] || "_missing"
      @terms_field = options[:terms_field] || "#{field}.untouched"
      @size = options[:size] || 10
    end

    def add_sanitized_params(params, sanitized_params)
      sanitized_params[@field] = params[@param_name] if active?(params)
    end

    def add_restrictions(params, search)
      search.filters << filter_definition(params) if active?(params)
    end

    def add_facet_definition(params, search)
      selected_terms_facet = facet_definition(50)
      other_terms_facet = facet_definition
      if active?(params)
        facet_filters = search.filters.clone
        facet_filters.delete(filter_definition(params))
        other_terms_facet[:global] = true
        other_terms_facet[:facet_filter] = {:and => facet_filters} if facet_filters.any?
      else
        selected_terms_facet = nil
      end
      search.facets[selected_terms_facet_name] = selected_terms_facet if selected_terms_facet
      search.facets[other_terms_facet_name] = other_terms_facet
    end

    def other_terms_facet_name
      "#{@name}_other"
    end

    def selected_terms_facet_name
      "#{@name}_selected"
    end

    def quicksearch(params, search)
      other_terms_facet = facet_definition
      facet_filters = search.filters.clone
      facet_filters << {:query => {:query_string => {
          :query => "#{params[:term]}*",
          :default_operator => :and,
          :default_field => @field,
          :analyze_wildcard => true,
      }}}
      facet_filters.delete(filter_definition(params))
      other_terms_facet[:global] = true
      other_terms_facet[:facet_filter] = {:and => facet_filters} if facet_filters.any?
      search.facets[selected_terms_facet_name] = facet_definition(50) if active?(params)
      search.facets[other_terms_facet_name] = other_terms_facet
    end

    private
    def active?(params)
      params[@param_name].present?
    end

    def filter_definition(params)
      terms = params[@param_name].is_a?(Array) ? params[@param_name] : [params[@param_name]]
      if terms.include?(@missing_param_value)
        {:bool => {
            :should => [
                {:terms => {@terms_field => terms}},
                {:missing => {:field => @field}}
            ]
        }}
      else
        {:terms => {@terms_field => terms}}
      end
    end

    def facet_definition(size = nil)
      {:terms => {
          :field => @terms_field,
          :size => size || @size
      }}
    end

    protected
    def create_populated_facet(params, response)
      selected_terms = params[@param_name].is_a?(Array) ? params[@param_name] : [params[@param_name]]
      selected_items = []
      other_items = []

      if response.facets.respond_to?(selected_terms_facet_name)
        data = response.facets.send(selected_terms_facet_name)
        data.terms.each do |item|
          actual_params, add_params, remove_params = generate_params(params, item.term)
          term = Populated::Term.new(item.term, item.count, true, actual_params, add_params, remove_params)
          selected_items << term
        end
      end

      data = response.facets.send(other_terms_facet_name)
      data.terms.each do |item|
        selected = selected_terms.include?(item.term)
        actual_params, add_params, remove_params = generate_params(params, item.term)
        term = Populated::Term.new(item.term, item.count, selected, actual_params, add_params, remove_params)
        other_items << term unless selected
      end

      if data.missing.to_i > 0
        selected = selected_terms.include?(@missing_param_value)
        actual_params, add_params, remove_params = generate_params(params, @missing_param_value)
        (selected ? selected_items : other_items) << Populated::Term.new(nil, data.missing, selected, actual_params, add_params, remove_params)
      end
      # TODO refactor ^^^
      Populated.new(selected_items, other_items, params, @name)
    end

    private

    def generate_params(params, value)
      actual_values = [params[@param_name]].flatten.compact # make it an array

      actual_params = params.clone
      actual_params[@param_name] = value

      add_params = params.clone
      remove_params = params.clone

      if actual_values.any?
        add_params[@param_name] = actual_values + [value]
        remove_params[@param_name] = actual_values - [value]
      else
        add_params[@param_name] = [value]
      end
      normalize(add_params, @param_name)
      normalize(remove_params, @param_name)

      [actual_params, add_params, remove_params]
    end

    def denormalize(params, name)
      params[name] = [params[name]].flatten unless params[name].is_a?(Array)
    end

    def normalize(params, name)
      return unless params[name] # TODO wtf?
      params[name].uniq!
      params[name] = params[name].first if params[name].size < 2
    end

    class Populated < Struct.new(:selected_terms, :other_terms, :params, :name)
      def terms
        selected_terms + other_terms
      end

      class Term < Struct.new(:term, :count, :selected, :params, :add_params, :remove_params)
        def selected?
          selected
        end

        def missing?
          !!term
        end
      end
    end
  end
end

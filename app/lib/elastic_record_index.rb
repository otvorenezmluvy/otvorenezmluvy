class ElasticRecordIndex
  def initialize(document_class, index_name, configuration)
    @document_class, @index_name = document_class, index_name
    @url = "http://#{configuration.host}:#{configuration.port}"
  end

  def exists?
    Curl::Easy.http_get(index_url(:_status)).response_code == 200
  end

  def delete_index
    Curl::Easy.http_delete(index_url)
  end

  def recreate
    delete_index
    response = Curl::Easy.http_put(index_url, @document_class.mapping.to_json)
    raise Exception.new(response.body_str) unless response.response_code == 200
    reregister_heuristics
  end

  def flush
    Curl::Easy.http_get index_url(:_flush)
  end

  def index(document)
    response = Curl::Easy.http_post(type_url(document.id), document.to_indexable.to_json)
    raise Exception.new(response.body_str) if response.response_code == 500
  end

  def get(id)
    response = Curl::Easy.http_get(type_url(id))
    response.response_code == 200 ? create_hit(parse_response(response.body_str)) : nil
  end

  def search(query)
    response = Curl::Easy.http_post(type_url("_search"), query.to_json)
    return parse_search_response(response.body_str) if response.response_code == 200
    raise Exception.new(response.body_str)
  end

  def delete(document)
    Curl::Easy.http_delete type_url(document.id)
  end

  def total_percolators
    response = Curl::Easy.http_get(percolator_url(:_search, :search_type => :count)).body_str
    parse_response(response).hits.total.to_i
  end

  def flush_percolators
    Curl::Easy.http_get "#{@url}/_percolator/_flush"
  end

  def register_percolator(identifier, query)
    Curl::Easy.http_put(percolator_url(identifier), query.to_json)
  end

  def has_percolator?(identifier)
    Curl::Easy.http_get(percolator_url(identifier)).response_code == 200
  end

  def remove_percolator(identifier)
    Curl::Easy.http_delete(percolator_url(identifier)).response_code == 200
  end

  def percolate(document)
    response = Curl::Easy.http_post(type_url(:_percolate), {:doc => document.to_indexable}.to_json).body_str
    parse_response(response).matches
  end

  def find_each(query, &block)
    # TODO optimize - query.search_type = :scan?
    # TODO optimize - bigger limit for scroll / parameter batch_size?
    scroll_id = nil
    processed = 0
    begin
      unless scroll_id
        result = initiate_scroll(query)
        scroll_id = result.scroll_id
      else
        result = scroll(scroll_id)
      end
      result.hits.each do |document|
        yield document
      end
      processed += result.hits.size
    end while processed < result.hits.total
  end

  def reindex_all(includes = nil)
    # TODO bulk?
    scope = includes ? @document_class.includes(includes) : @document_class
    scope.find_each do |doc|
      index(doc)
    end
  end

  private
  def reregister_heuristics
    Heuristic.all.each do |heuristic|
      heuristic.register(self, ::Configuration.factic)
    end
  end

  def scroll(scroll_id, timeout = "5m")
    response = Curl::Easy.http_get("#{@url}/_search/scroll?scroll_id=#{scroll_id}&scroll=#{timeout}").body_str
    parse_search_response(response)
  end

  def initiate_scroll(query, timeout = "5m")
    response = Curl::Easy.http_post(type_url("_search?scroll=#{timeout}"), query.to_json).body_str
    parse_search_response(response)
  end

  def percolator_url(identifier = nil, options = {})
    serialized = options.collect { |k, v| "#{k}=#{v}" }.join('&')
    [@url, '_percolator', @index_name, identifier, '?', serialized].compact.join('/')
  end

  def index_url(action_or_id = nil)
    [@url, @index_name, action_or_id].compact.join('/')
  end

  def type_url(action_or_id)
    [index_url, index_type, action_or_id].join('/')
  end

  def index_type
    @document_class.to_s.downcase
  end

  def parse_search_response(response)
    results = parse_response(response)
    raw_hits = results.hits.hits.collect do |data|
      create_hit(data)
    end
    hits = Hits.new(raw_hits, results.hits.total, results.hits.max_score)
    Results.new(hits, results.facets, results.took, results._scroll_id)
  end

  def create_hit(data)
    Hit.new(@document_class, data)
  end

  def parse_response(response)
    ActiveSupport::JSON.decode(response).to_openstruct
  end

  class Results
    attr_reader :hits, :facets, :took, :scroll_id
    delegate :any?, :each_with_index, :to => :hits

    def initialize(hits, facets, took, scroll_id)
      @hits, @facets, @took, @scroll_id = hits, facets, took, scroll_id
    end
  end

  class Hits < Array
    attr_accessor :total, :max_score

    def initialize(hits, total, max_score)
      super(hits)
      @total, @max_score = total, max_score
    end
  end

  class Hit
    include Document::NormalizedPoints
    include Document::NiceUrl

    undef id

    def initialize(document_class, data)
      @document_class, @data = document_class, data
    end

    def method_missing(method, *args)
      if method.to_s =~ /highlighted_(.+)/
        highlights($1).first.try(:html_safe) || get_field($1)
      else
        get_field(method)
      end
    end

    def ==(other)
      get_field(:id) == other.get_field(:id)
    end

    def highlights(field_name)
      return [] unless @data.highlight
      @data.highlight.send(field_name) || []
    end

    def object
      @document_class.find(@data._id)
    end

    protected
    def get_field(name)
      return @data._id.to_i if name == :id # id is special
      return @data._source.send(name) if @data._source && @data._source.respond_to?(name)
      return @data.fields.send(name) if @data.fields && @data.fields.respond_to?(name)
      return nil
      raise NoMethodError.new("Field #{name} not loaded into hit, try loading it or use object method to get underlying object", name)
    end
  end

  class Exception < RuntimeError
  end
end

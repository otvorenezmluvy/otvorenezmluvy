class DocumentsRepository
  def initialize(index, heuristic_listener, document_listener)
    @index = index
    @heuristic_listener = heuristic_listener
    @document_listener = document_listener
  end

  def save(document)
    document.matching_heuristics = Heuristic.find_matching_heuristics(@index, document)
    if result = document.save
      @index.index(document)
      @document_listener.document_saved(document)
    end
    result
  end

  def save!(document)
    document.matching_heuristics = Heuristic.find_matching_heuristics(@index, document)
    if result = document.save!
      @index.index(document)
      @document_listener.document_saved(document)
    end
    result
  end

  def create_heuristic(params, translator)
    # TODO extract search params from factic to prevent search injections
    if heuristic = Heuristic.create(params)
      heuristic.register(@index, translator)
      @heuristic_listener.heuristic_created(heuristic, translator)
    end
    heuristic
  end

  def update_heuristic(heuristic, params, translator)
    result = heuristic.update_attributes(params)
    @heuristic_listener.heuristic_updated(heuristic, translator) if result
    result
  end

  def destroy_heuristic(heuristic, translator)
    result = heuristic.destroy
    @heuristic_listener.heuristic_destroyed(heuristic, translator) if result
    result
  end

  def search(query)
    @index.search(query)
  end

  def find_each(query, &block)
    @index.find_each(query) do |document|
      yield(document)
    end
  end

  def reindex_by_query(query)
    @index.find_each(query) do |document|
      @index.index(document.object)
    end
  end

  def recreate
    @index.recreate
  end

  def reindex_all
    @index.reindex_all(:attachments => :pages)
  end

  def statistics
    search = Factic::Search.new
    search.facets[:all] = {:filter => {:match_all => ''}, :global => true}
    search.facets[:amounts] = {:statistical => {:field => :total_amount}, :global => true}
    search.facets[:amounts_from_last_week] = {:statistical => {:field => :total_amount}, :facet_filter => {:numeric_range => { :published_on => {:gt => 7.days.ago}}}}
    search.facets[:amounts_by_department] = {:terms_stats => {:key_field => "department.untouched", :value_field => :total_amount, :order => :total, :size => 5}, :global => true}
    @index.search(search).facets
  end

  def most_commented
    search = Factic::Search.new
    search.sort << {:comments_count => :desc}
    search.filters << {:numeric_range => {:comments_count => {:gt => 0}}}
    search.size = 5
    @index.search(search)
  end

  def most_recent(min_points, days_back)
    search = Factic::Search.new
    search.filters << {:numeric_range => {:published_on => {:gte => days_back.days.ago}}}
    search.filters << {:numeric_range => {:points => {:gte => min_points}}}
    search.scoring_function = 'random()'
    search.size = 5
    @index.search(search)
  end
end

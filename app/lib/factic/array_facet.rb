# encoding: utf-8
class Factic::ArrayFacet
  def initialize(name, user_id)
    @name = name
    @user_id = user_id
  end

  def add_sanitized_params(params, sanitized_params)
    sanitized_params[:watched] = params[:watched] if params[:watched]
    sanitized_params[:opened] = params[:opened] if params[:opened]
  end

  def add_facet_definition(params, search)
    watcher_facet = {filter: {term: {watcher_ids: @user_id}}}
    opener_facet = {filter: {term: {opener_ids: @user_id}}}

    if params[:watched] || params[:opened]
      facet_filters = search.filters.clone
      facet_filters.delete(filter_definition(params))
      watcher_facet[:global] = true
      watcher_facet[:facet_filter] = {and: facet_filters} if facet_filters.any?
      opener_facet[:global] = true
      opener_facet[:facet_filter] = {and: facet_filters} if facet_filters.any?
    end

    search.facets[:watched_count_facet] = watcher_facet
    search.facets[:opened_count_facet] = opener_facet
  end

  def name
    @name
  end

  def add_restrictions(params, search)
    definition = filter_definition(params)
    search.filters << definition if definition.any?
  end

  def filter_definition(params)
    filters = []
    filters << {:term => {watcher_ids: @user_id}} if params[:watched]
    filters << {:term => {opener_ids: @user_id}} if params[:opened]
    filters.any? ? {or: filters} : {}
  end

  def populate(results, params, response)
    results.facets[@name] = create_populated_facet(params, response)
  end

  private
  def create_populated_facet(params, response)
    Populated.new(
        [
            Populated::Term.new('Sledované', response.facets.watched_count_facet.count, params[:watched], params.except(:opened).merge({watched: true}), params.merge({watched: true}), params.except(:watched)),
            Populated::Term.new('Otvorené', response.facets.opened_count_facet.count, params[:opened], params.except(:watched).merge({opened: true}), params.merge({opened: true}), params.except(:opened))
        ]
    )
  end


  class Populated < Struct.new(:terms, :params, :name)
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

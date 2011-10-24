class Factic
  class StatisticalFacet < Facet
    def initialize(field, options = {})
      options[:name] = options[:name] || "#{field}_stats"
      super(field, options)
    end

    def add_facet_definition(params, search)
      search.facets[name] = facet_definition
    end

    def facet_definition
      {:statistical => {
          :field => @field
      }}
    end

    def create_populated_facet(params, response)
      response.facets.send(name)
    end
  end
end
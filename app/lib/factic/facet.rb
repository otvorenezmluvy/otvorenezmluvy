class Factic
  class Facet
    attr_reader :name

    def initialize(field, options = {})
      @field = field
      @options = options
      @name = options[:name] || field
    end

    def populate(results, params, response)
      results.facets[@name] = create_populated_facet(params, response)
    end
  end
end
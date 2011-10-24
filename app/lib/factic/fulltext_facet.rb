class Factic
  class FulltextFacet < Facet
    def add_restrictions(params, search)
      return if params[name].blank?
      search.query = query_definition(params)
      search.filters << filter_definition(params)
    end

    def add_sanitized_params(params, sanitized_params)
      sanitized_params[name] = params[name] if active?(params)
    end

    def create_populated_facet(params, response)
      actual_params = params.clone
      remove_params = params.clone
      remove_params[@name] = nil
      Populated.new(params[@name], actual_params, remove_params)
    end

    protected
    def filter_definition(params)
      {:query => query_definition(params)}
    end

    private
    def query_definition(params)
      {:query_string => {
                          :query => params[name],
                          :default_operator => :and
      }}
    end

    def active?(params)
      params[name].present?
    end

    class Populated < Struct.new(:query_string, :params, :remove_params)
      def applied?
        query_string.present?
      end
    end
  end
end
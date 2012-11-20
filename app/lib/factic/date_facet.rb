class Factic
  class DateFacet < Facet
    def initialize(field, options = {})
      super(field, options)
      @param_name = options[:param_name] || field
      @interval = options[:interval] || :month
    end

    def add_sanitized_params(params, sanitized_params)
      sanitized_params[@param_name] = params[@param_name] if active?(params)
    end

    def add_restrictions(params, search)
      search.filters << filter_definition(params) if active?(params)
    end

    def add_facet_definition(params, search)
      facet = facet_definition
      missing_facet = {:terms => {:field => @field, :size => 0}}
      if active?(params)
        facet_filters = search.filters.clone
        facet_filters.delete(filter_definition(params))
        facet[:global] = true
        facet[:facet_filter] = {:and => facet_filters} if facet_filters.any?

        missing_facet[:global] = true
        missing_facet[:facet_filter] = {:and => facet_filters} if facet_filters.any?
      end
      search.facets[@field] = facet
      search.facets[missing_facet_name] = missing_facet
    end

    def missing_facet_name
      "#{@field}_missing"
    end

    private
    def active?(params)
      params[@param_name].present? || params["#{@param_name}_from"].present? || params["#{@param_name}_to"].present?
    end

    def filter_definition(params)
      ranges = params[@param_name].is_a?(Array) ? params[@param_name] : [params[@param_name]]
      {:bool => {
          :should => ranges.collect do |param|
            range = parse_range(param)
            if param == "_missing"
              {:missing => {:field => @field}}
            else
              {:range => {
                  @field => {:from => range.begin, :to => range.end}
              }}
            end
          end
      }}
    end

    def facet_definition
      {:date_histogram => {
          :field => @field,
          :interval => @interval
      }}
    end

    def create_populated_facet(params, response)
      ranges = response.facets.send(@field).entries.reverse.collect do |entry|
        first = Time.at(entry.time / 1000).to_date
        range = first..end_of_interval(first)
        actual_params, add_params, remove_params = create_params(range, params)
        selected = params[@param_name] && params[@param_name].include?(create_param(range))
        Populated::Range.new(range, entry.count, selected, actual_params, add_params, remove_params)
      end
      # TODO missing count
      Populated.new(ranges)
    end

    private
    def parse_range(value)
      from, to = value.split('..')
      parse_date(from)..parse_date(to)
    end

    def create_param(range)
      "#{range.begin.to_s(:db)}..#{range.end.to_s(:db)}"
    end

    def parse_date(value)
      Date.strptime(value, "%Y-%m-%d")
    end

    def create_params(range, params)
      actual_params = params.clone
      values = [params[@param_name]].flatten.compact
      value = create_param(range)

      actual_params[@param_name] = value
      add_params = actual_params.clone
      add_params[@param_name] = (values + [value]).uniq
      remove_params = actual_params.clone
      remove_params[@param_name] = values - [value]
      [actual_params, add_params, remove_params]
    end

    def end_of_interval(date)
      case @interval
        when :month
          date.end_of_month
        when :year
          date.end_of_year
      end
    end
  end

  class Populated < Struct.new(:ranges)
    class Range < Struct.new(:range, :count, :selected, :params, :add_params, :remove_params)
      def selected?
        selected
      end

      def missing?
        range.nil?
      end
    end
  end
end
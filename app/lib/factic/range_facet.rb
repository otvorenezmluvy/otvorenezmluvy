Infinity = 1.0/0

class Factic
  class RangeFacet < Facet
    def initialize(field, ranges, options = {})
      super(field, options)
      @param = Parameter.new(options[:param_name] || field)
      @ranges = ranges
      @converter = converter_for(ranges.first.begin.class)
    end

    def add_sanitized_params(params, sanitized_params)
      if active?(params)
        sanitized_params[@param.from] = params[@param.from]
        sanitized_params[@param.to] = params[@param.to]
        sanitized_params[@param.name] = params[@param.name]
      end
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
      params[@param.name].present?  || params[@param.from].present? || params[@param.to].present?
    end

    def filter_definition(params)
      if params[@param.from] || params[@param.to]
        specific_range_filter(params)
      else
        range_filter(params)
      end
    end

    def specific_range_filter(params)
      {:bool => {
          :should => {
              :range => {
                  @field => {}.tap do |range|
                    range[:from] = sanitize_range_boundary(params[@param.from]) unless params[@param.from].blank?
                    range[:lt] = sanitize_range_boundary(params[@param.to]) unless params[@param.to].blank?
                  end
              }
          }
      }}
    end

    def range_filter(params)
      ranges = params[@param.name].is_a?(Array) ? params[@param.name] : [params[@param.name]]
      {:bool => {
          :should => ranges.collect do |param|
            if param == "_missing"
              {:missing => {:field => @field}}
            else
              {:range => {
                  @field => parse_range(param)
              }}
            end
          end
      }}
    end

    def facet_definition
      ranges = []
      ranges << {:to => @converter.to_elastic(@ranges.first.begin)}
      @ranges.each do |range|
        ranges << {:from => @converter.to_elastic(range.begin), :to => @converter.to_elastic(range.end)}
      end
      ranges << {:from => @converter.to_elastic(@ranges.last.end)}

      {:range => {
          :field => @field,
          :ranges => ranges
      }}
    end

    protected
    def create_populated_facet(params, response)
      selected_ranges = params[@param.name].is_a?(Array) ? params[@param.name] : [params[@param.name]]
      data = response.facets.send(name)
      ranges = []
      data.ranges.each do |entry|
        next unless entry.total_count > 0
        from = entry.from ? @converter.from_elastic(entry.from) : @converter.lower_bound
        to = entry.to ? @converter.from_elastic(entry.to) : @converter.upper_bound
        range = from..to
        actual_params, add_params, remove_params = generate_params(params, range)
        ranges << Populated::Range.new(range, entry.total_count, selected_ranges.include?(create_param(range)), actual_params, add_params, remove_params)
      end
      missing_count = response.facets.send(missing_facet_name).missing
      if missing_count > 0
        actual_params, add_params, remove_params = generate_params(params, nil)
        ranges << Populated::Range.new(nil, missing_count, selected_ranges.include?("_missing"), actual_params, add_params, remove_params)
      end
      Populated.new(ranges, params)
    end

    private

    def sanitize_range_boundary(boundary)
      cleaned = boundary.gsub(/[^0-9\.,]/, '').gsub(',', '.')
      if cleaned.empty?
        0
      else
        cleaned
      end
    end

    def create_param(range)
      return "_missing" if range.nil?
      return "<#{@converter.to_elastic(range.end)}" if range.begin == @converter.lower_bound
      return ">#{@converter.to_elastic(range.begin)}" if range.end == @converter.upper_bound
      "#{@converter.to_elastic(range.begin)}..#{@converter.to_elastic(range.end)}"
    end

    def parse_range(range)
      if range =~ /<(.+)/
        return {:lt => $1}
      end
      if range =~ />(.+)/
        return {:from => $1}
      end
      if range =~ /(.+)\.\.(.+)/
        {:from => $1, :lt => $2}
      end
    end

    def generate_params(params, range)
      value = create_param(range)
      actual_values = [params[@param.name]].flatten.compact # make it an array

      actual_params = params.clone
      actual_params[@param.name] = value

      add_params = params.clone
      remove_params = params.clone

      if actual_values.any?
        add_params[@param.name] = actual_values + [value]
        remove_params[@param.name] = actual_values - [value]
      else
        add_params[@param.name] = [value]
      end
      normalize(add_params, @param.name)
      normalize(remove_params, @param.name)
      remove_specific_range_params(actual_params, @param.name)

      [actual_params, add_params, remove_params]
    end

    def normalize(params, name)
      return unless params[name].present?
      params[name].uniq!
      params[name] = params[name].first if params[name].size < 2
      remove_specific_range_params(params, name)
    end

    def remove_specific_range_params(params, name)
      params.delete(@param.from)
      params.delete(@param.to)
    end

    class Populated < Struct.new(:ranges, :params)
      class Range < Struct.new(:range, :count, :selected, :params, :add_params, :remove_params)
        def selected?
          selected
        end

        def missing?
          range.nil?
        end
      end
    end

    class Parameter
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def from
        "#{@name}_from"
      end

      def to
        "#{@name}_to"
      end
    end

    def converter_for(klass)
      if klass == Fixnum
        Converters::Numeric
      elsif klass == Date
        Converters::Date
      else
        raise "No converter for class #{klass}"
      end
    end

    class Converters
      class Numeric
        def self.from_elastic(value)
          value
        end
        def self.to_elastic(value)
          value.to_i
        end
        def self.upper_bound
          Infinity
        end
        def self.lower_bound
          -Infinity
        end
      end

      class Date
        def self.from_elastic(value)
          Time.at(value / 1000).to_date
        end

        def self.to_elastic(value)
          value.to_s
        end
        def self.upper_bound
          ::Date.civil(9999, 12, 31)
        end
        def self.lower_bound
          ::Date.civil(0, 1, 1)
        end
      end
    end
  end
end

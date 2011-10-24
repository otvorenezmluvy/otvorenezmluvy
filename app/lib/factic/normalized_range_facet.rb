class Factic
  class NormalizedRangeFacet < RangeFacet
    include Normalization

    def initialize(field, range, options)
      super
      @normalized_to = options[:normalized_to]
    end

    def facet_definition
      ranges = []
      ranges << {:to => denormalize_points(@ranges.first.begin, @normalized_to)}
      @ranges.each do |range|
        ranges << {:from => denormalize_points(range.begin, @normalized_to), :to => denormalize_points(range.end, @normalized_to)}
      end
      ranges << {:from => denormalize_points(@ranges.last.end, @normalized_to)}

      {:range => {
          :field => @field,
          :ranges => ranges
      }}
    end

    def create_populated_facet(params, response)
      populated = super
      populated.ranges.each do |range|
        range.range = normalize_points(range.range.begin, @normalized_to)..normalize_points(range.range.end, @normalized_to)
      end
      populated
    end

  end
end

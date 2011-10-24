module Document::NormalizedPoints
  include Normalization

  def normalized_points
    normalize_points(points, Configuration.normalize_points_to)
  end

  def denormalized_points
    denormalize_points(points, Configuration.normalize_points_to)
  end
end

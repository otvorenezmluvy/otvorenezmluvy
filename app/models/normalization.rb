module Normalization
  Infinity = 1.0/0

  def normalize_points(points, to)
    return points if points == Infinity || points == -Infinity
    to = 1 if to == 0
    normalized = points.to_f / to.to_f * 10
    normalized.round.to_i
  end

  def denormalize_points(normalized_points, from)
    return normalized_points if normalized_points == Infinity || normalized_points == -Infinity
    normalized_points * from / 10
  end

end

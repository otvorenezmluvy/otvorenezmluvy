class SpaceshipSetting < ActiveRecord::Base
  include Normalization
  attr_accessible :label, :value

  def denormalized_value
    denormalize_points(value,Configuration.normalize_points_to)
  end
end
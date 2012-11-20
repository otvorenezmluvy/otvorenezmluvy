class Event < ActiveRecord::Base
  attr_accessible :for_user, :external

  belongs_to :for_user, class_name: 'User'
  belongs_to :external, polymorphic: true

  def to_partial_path
    "events/#{self.class.to_s.underscore}"
  end

  def aggregate_parent
    nil
  end

  def aggregate_parent_type
    nil
  end
end

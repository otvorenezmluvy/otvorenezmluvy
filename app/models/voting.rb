class Voting < ActiveRecord::Base
  attr_accessible :up_or_down, :user

  belongs_to :user
  belongs_to :comment
end

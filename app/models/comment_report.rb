class CommentReport < ActiveRecord::Base
  belongs_to :comment, :counter_cache => :reports_count
  belongs_to :user
  attr_accessible :body, :user
end

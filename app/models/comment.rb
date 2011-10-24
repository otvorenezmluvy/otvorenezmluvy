class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  belongs_to :document

  has_many :replies, :class_name => 'Comment', :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :class_name => 'Comment'

  validates :comment, :presence => true

  def author_label
    user.try(:label) || 'Anonym'
  end

  def related_to_document_area?
    area
  end
end

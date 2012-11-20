class Comment < ActiveRecord::Base
  attr_accessible :comment, :user, :votes, :parent, :area, :document

  belongs_to :page
  belongs_to :user
  belongs_to :document
  belongs_to :censored_by, class_name: 'User'

  has_many :replies, :class_name => 'Comment', :foreign_key => :parent_id, :dependent => :destroy
  belongs_to :parent, :class_name => 'Comment'
  has_many :votings
  has_many :reports, :class_name => 'CommentReport', dependent: :destroy

  validates :comment, :presence => true

  scope :censored, where('censored_at IS NOT NULL')
  scope :uncensored, where(censored_at: nil)
  scope :reported, where('reports_count > 0')
  scope :chronologically, order('id DESC')
  scope :by_last_change, order('updated_at DESC')

  def author_label
    user.try(:label) || 'Anonym'
  end

  def related_to_document_area?
    area
  end

  def toggle(censor)
    update_column(:censored_at, censored? ? nil : DateTime.now)
    update_column(:censored_by_id, censor.id)
  end

  def censored?
    censored_at?
  end

  def replies_count
    replies.count
  end
end

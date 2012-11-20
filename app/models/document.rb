require_association 'crz/document'
require_association 'egovsk/document'


class Document < ActiveRecord::Base
  has_and_belongs_to_many :matching_heuristics, :class_name => 'Heuristic', :uniq => true # do not allow heuristics duplication
  has_many :comments, :order => 'votes DESC, created_at DESC', :include => [:user, { :replies => [:user] }], :conditions => 'parent_id IS NULL'
  has_many :comments_including_replies, :order => 'votes DESC, created_at DESC', :include => [:user, { :replies => [:user] }], :class_name => 'Comment'
  has_many :question_answers

  has_many :watchlists
  has_many :watchers, through: :watchlists, class_name: 'User', source: :user
  has_many :document_openings

  include Document::Indexable
  include Document::NormalizedPoints
  include Document::NiceUrl

  def points
    matching_heuristics.reduce(0) { |sum, heuristic| sum + heuristic.on(self).points }
  end

  def comments_count
    comments_including_replies.count # TODO counter_cache?
  end

  def watcher_ids
    watchers.collect(&:id)
  end

  def opener_ids
    document_openings.collect(&:user_id)
  end
end

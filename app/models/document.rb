require_association 'crz/document'
require_association 'egovsk/document'


class Document < ActiveRecord::Base
  has_and_belongs_to_many :matching_heuristics, :class_name => 'Heuristic', :uniq => true # do not allow heuristics duplication
  has_many :comments, :order => 'votes DESC, created_at DESC', :include => [:user, { :replies => [:user] }], :conditions => 'parent_id IS NULL'

  include Document::Indexable
  include Document::NormalizedPoints
  include Document::NiceUrl

  def points
    matching_heuristics.reduce(0) { |sum, heuristic| sum + heuristic.on(self).points }
  end

  def comments_count
    comments.count # TODO counter_cache?
  end
end

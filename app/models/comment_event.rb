class CommentEvent < Event
  attr_accessible :comment
  belongs_to :comment, foreign_key: :external_id, foreign_type: :external_type, polymorphic: true

  def aggregate_parent
    comment.document
  end

  def aggregate_parent_type
    :document
  end
end
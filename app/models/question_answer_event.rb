class QuestionAnswerEvent < Event
  belongs_to :document, foreign_key: :external_id, foreign_type: :external_type, polymorphic: true

  def aggregate_parent
    external.document
  end

  def aggregate_parent_type
    :document
  end
end

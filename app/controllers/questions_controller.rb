class QuestionsController < ApplicationController
  def create
      q = QuestionAnswer.find_or_initialize_by_document_id_and_question_id_and_user_id(params[:document_id], params[:question], current_or_guest_user.id)
      q.question_choice_id = params[:choice]
      q.detail = params[:detail]
      q.save

      answered_count = QuestionAnswer.where(:document_id => params[:document_id], :user_id => current_or_guest_user.id).count

    render :json => (100*answered_count.to_f/Question.count.to_f).to_i
  end
end
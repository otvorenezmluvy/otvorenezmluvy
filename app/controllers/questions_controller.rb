class QuestionsController < ApplicationController
  def create
      q = QuestionAnswer.find_or_initialize_by_document_id_and_question_id(params[:document_id], params[:question])
      if(current_or_guest_user.guest)
        q.guest_user_id = current_or_guest_user.id
      else
        q.user_id = current_or_guest_user.id
      end
      q.question_choice_id = params[:choice]
      q.detail = params[:detail]
      q.save

      current_user.log_question_answered(q) if current_user

      answered_count = 1
      if(current_or_guest_user.guest)
        answered_count = QuestionAnswer.where(:document_id => params[:document_id], :guest_user_id => current_or_guest_user.id).count
      else
        answered_count = QuestionAnswer.where(:document_id => params[:document_id], :user_id => current_or_guest_user.id).count
      end

    render :json => (100*answered_count.to_f/Question.count.to_f).to_i
  end
end
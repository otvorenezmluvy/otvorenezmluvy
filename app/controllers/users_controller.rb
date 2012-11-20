class UsersController < AuthorizedController
  def show
    @body_class = "detail user"

    @user = User.find(params[:id])
    @recent_comments = @user.comments.order('comments.id DESC').limit(5)
    @recent_question_answers = @user.question_answers.select("document_id, MAX(created_at) AS created_at").group("document_id").order("MAX(created_at) DESC").limit(5)
    @watched_documents = @user.watched_documents
  end
end
class Admin::ReportsController < AdminController
  before_filter :authenticate_user!
  check_authorization
  authorize_resource :class => "CommentReport"

  def index
    @comment = Comment.find(params[:comment_id])
    @reports = @comment.reports
  end
end

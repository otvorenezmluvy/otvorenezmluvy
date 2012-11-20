class Admin::CommentsController < AdminController
  authorize_resource

  def index
    @latest = Comment.chronologically.limit(10)
    @comments = Comment.censored.by_last_change.page(params[:page])
    @reports = CommentReport.includes(:comment).order('id DESC').page(params[:page])
    @suspicious_comments = Comment.where('flags > 0').by_last_change.page(params[:page])
  end
end

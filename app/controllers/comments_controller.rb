class CommentsController < ApplicationController

  before_filter :find_document
  before_filter :find_comment, :except => :create

  def create
    if params[:area]
      attachment = @document.attachments.find_by_number(params[:attachment_number])
      page = attachment.pages.find_by_number(params[:page_number])
      @comment = page.comments.build(:comment => params[:comment], :area => params[:area].to_json, :user => current_user, :document => @document)
    else
      if params[:comment][:reply_to].empty?
        @comment = @document.comments.build(:comment => params[:comment][:comment], :user => current_user)
      else
        @comment = Comment.find(params[:comment][:reply_to])
        reply = @document.comments.build(:comment => params[:comment][:comment], :user => current_user, :parent => @comment)
      end
    end

    new_comment = reply ? reply : @comment

    if !current_user || current_user.guest?
      new_comment.save if verify_recaptcha(:model => @comment, :message => I18n.t('recaptcha.errors.verification_failed'))
    else
      new_comment.save
    end

    ::Configuration.documents_repository.save(@document) unless new_comment.errors.any?

    respond_to do |format|
      format.js
      format.html { redirect_to document_path(@document) }
    end
  end

  def destroy
    @comment.destroy if current_user.admin?

    respond_to do |format|
      format.js { render :nothing => true }
      format.html { redirect_to document_path(@document) }
    end
  end

  def vote_up
    vote(:up)
  end

  def vote_down
    vote(:down)
  end

  def flag
    unless @comment.mail_sent
      @comment.flags = @comment.flags + 1
      if @comment.flags == SpaceshipSetting.find_by_identifier("flagged_comment_threshold").value
        @comment.mail_sent = true
        NotificationMailer.flagged_comment_warning(@comment).deliver
      end
      @comment.save
    end
    respond_to do |format|
      format.js { render :json => @comment }
      format.html { redirect_to document_path(@document) }
    end
  end

  private

  def vote(up_or_down)
    render :status => :unauthorized, :nothing => true and return unless current_user
    render :status => :forbidden, :nothing => true and return if current_user.already_voted_for?(@comment, up_or_down)

    current_user.vote_for(@comment, up_or_down)

    respond_to do |format|
      format.js { render :json => @comment }
      format.html { redirect_to document_path(@document) }
    end
  end

  def find_document
    @document = Document.find(params[:document_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

end

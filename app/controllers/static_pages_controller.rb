class StaticPagesController < ApplicationController
  before_filter :ensure_can_edit_page, :only => [:create, :update, :destroy]
  before_filter :set_body_class

  def show
    page = StaticPage.find_by_slug(params[:slug])
    raise ActiveRecord::RecordNotFound unless page
    @markdown = Redcarpet.new(page.content) if page.content
    @title = page.title
    @page = page if can? :edit, page
  end

  def update
    @page = StaticPage.find_by_slug(params[:slug])
    if @page.update_attributes(params[:static_page])
      redirect_to static_page_path(@page.slug)
    else
      render :action => :show
    end
  end

  private

  def ensure_can_edit_page
    authorize! :edit, StaticPage
  end

  def set_body_class
    @body_class = "detail static"
  end

end

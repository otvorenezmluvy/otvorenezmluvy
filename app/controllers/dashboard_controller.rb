class DashboardController < ApplicationController
  before_filter :set_body_class

  def show
    authorize! :view, :dashboard

    if params[:per_page] && params[:per_page].to_i <= 50
      current_user.update_attribute(:results_per_page, params[:per_page])
      redirect_to dashboard_path and return
    end

    @filters = current_user.stream_filters
    @page = (params[:page] || 1).to_i
    @per_page = current_user.results_per_page

    # TODO populate from filters
    @events = current_user.dashboard_events.page(@page).per(@per_page)

    documents = @events.select { |e| e.respond_to?(:document) }.collect(&:document) # not all events have document!
    @watched_documents = current_user.select_watched_documents(documents)
  end

  def filter
    filters = params[:filters] || {}
    current_user.stream_show_openings = filters[:show_openings] || false
    current_user.stream_show_watching = filters[:show_watching] || false
    current_user.stream_show_my_comments = filters[:show_my_comments] || false
    current_user.stream_show_other_comments = filters[:show_other_comments] || false
    current_user.stream_show_answers = filters[:show_answers] || false
    current_user.save!
    redirect_to dashboard_path
  end

  private
  def set_body_class
    @body_class = "detail"
  end
end

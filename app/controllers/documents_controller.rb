# encoding: utf-8
class DocumentsController < ApplicationController
  before_filter :set_body_class
  caches_action :index, :layout => false, :expires_in => 10.minutes

  after_filter :log_document_opened, only: :show

  def index
    @statistics = documents_repository.statistics
    @most_recent = documents_repository.most_recent(SpaceshipSetting.find_by_identifier("recent_min_points").denormalized_value, SpaceshipSetting.find_by_identifier("recent_days").denormalized_value)
    @most_commented = documents_repository.most_commented
    @recent_comments = Comment.chronologically.limit(3).includes({ :document => :matching_heuristics }, :user)
    @query_facet = factic.quickfacet("q", params) # TODO get rid of this
  end

  def search
    session[:last_search] = params
    @title = "Vyhľadávanie"
    @query = params[:q] if params[:q].present?
    @visible_facet_names = [
        :customer, :supplier, :total_amount, :department, :comments_count, :published_on, :expires_on, :supplier_age, :appendixes_count,
        :supplier_nace, :source, :attachments_count, :total_pages_count, :legal_form, :ownership_category, :scope
    ]
    unless session[:hidden_facets]
      session[:hidden_facets] = [:attachments_count, :total_pages_count, :legal_form, :ownership_category]
    end

    @collapsed_facet_names = session[:hidden_facets]
    @sort_fields = [["Celkovej sumy", :total_amount], ["Dátumu zverejnenia", :published_on], ["Počtu komentárov", :comments_count]]
    params[:sort] ||= :total_amount
    params[:sort_order] ||= "desc"
    @results, @pages = search_documents(params) # TODO move pages search into repository?
    @restrictions_params = factic.extract_facets_params(params)
    @heuristic = Heuristic.find_or_initialize_by_search_parameters(@restrictions_params)
    @watched_documents = current_user.select_watched_documents(@results.hits) if current_user
  end

  def quickfacet
    # TODO visible facets only
    @facet_name = params[:facet]
    @facet = factic.quickfacet(@facet_name, params)
  end

  def show
    @last_search_params = session[:last_search].nil? ? {:action => :search} : {:action => :search}.reverse_merge(session[:last_search])
    @query = params[:q] if params[:q].present?
    @document = Document.find(params[:id])
    @attachments = @document.attachments.includes(:pages => :comments)
    @title = @document.title
    @matching_pages = @query ? pages_repository.search(@query, @document.id) : []

    @questions = @document.appendix? ? Question.for_appendix : Question.for_contract
    @visible_questions, @hidden_questions = @questions.partition(&:always_shown?)
    @watched_documents = current_user.select_watched_documents([@document]) if current_user
    if(current_or_guest_user.guest)
      @user_answers = QuestionAnswer.where(:document_id => @document.id, :guest_user_id => current_or_guest_user.id, :question_id => @questions.collect(&:id)).includes(:question_choice).group_by(&:question_choice)
    else
      @user_answers = QuestionAnswer.where(:document_id => @document.id, :user_id => current_or_guest_user.id, :question_id => @questions.collect(&:id)).includes(:question_choice).group_by(&:question_choice)
    end
  end

  def toggle_visibility
    if params[:to] == "collapsed"
      session[:hidden_facets] << params[:name].to_sym
    else
      session[:hidden_facets].delete(params[:name].to_sym)
    end
    render :nothing => true, :status => 200
  end

  def watch
    @document = Document.find(params[:id])
    current_user.watch(@document, params[:notice])
    render :nothing => true, :status => 200
  end

  def unwatch
    @document = Document.find(params[:id])
    current_user.unwatch(@document)
    render :nothing => true, :status => 200
  end

  private
  def search_documents(params)
    results = factic.search(params)
    doc_ids = results.hits.collect(&:id)
    pages_by_document_id = {}
    if params[:q].present? && doc_ids.any?
      pages_repository.search(params[:q], doc_ids).hits.each do |hit|
        pages_by_document_id[hit.attachment.document_id] ||= []
        pages_by_document_id[hit.attachment.document_id] << hit
      end
    end
    [results, pages_by_document_id]
  end

  def log_document_opened
    current_user.log_document_opened(@document) if current_user
  end

  def set_body_class
    @body_class = "detail" unless action_name == "index"
  end
end

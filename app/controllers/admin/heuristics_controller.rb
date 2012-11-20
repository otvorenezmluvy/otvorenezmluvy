class Admin::HeuristicsController < AdminController
  authorize_resource
  before_filter :find_heuristic, :only => [:update, :destroy]

  def index
    @heuristics = Heuristic.page(params[:page])
  end

  def create
    @heuristic = documents_repository.create_heuristic(params[:heuristic], factic) # TODO validation
    redirect_to search_documents_path(@heuristic.search_parameters)
  end

  def update
    documents_repository.update_heuristic(@heuristic, params[:heuristic], factic)
    redirect_to search_documents_path(@heuristic.search_parameters)
  end

  def destroy
    documents_repository.destroy_heuristic(@heuristic, factic)
    redirect_to search_documents_path(@heuristic.search_parameters)
  end

  private
  def find_heuristic
    @heuristic = Heuristic.find(params[:id])
  end
end

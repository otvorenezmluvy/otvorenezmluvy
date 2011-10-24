class HeuristicsController < AuthorizedController
  before_filter :find_heuristic, :only => [:update, :destroy]
  before_filter :set_body_class

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

  def set_body_class
    @body_class = "heuristic"
  end
end

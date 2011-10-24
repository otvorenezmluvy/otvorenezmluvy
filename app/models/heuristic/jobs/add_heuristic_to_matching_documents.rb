class Heuristic::Jobs::AddHeuristicToMatchingDocuments
  @queue = :heuristics

  def self.perform(id, query)
    heuristic = Heuristic.find(id)
    Configuration.documents_repository.find_each(query) do |hit|
      document = hit.object
      Configuration.documents_repository.save!(document)
    end
  end
end
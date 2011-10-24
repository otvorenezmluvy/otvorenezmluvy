class Heuristic::Jobs::ReindexMatchingDocuments
  @queue = :heuristics
  def self.perform(query)
    Configuration.documents_repository.reindex_by_query(query)
  end
end
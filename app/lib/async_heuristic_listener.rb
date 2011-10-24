class AsyncHeuristicListener
  def initialize(queue)
    @queue = queue
  end

  def heuristic_created(heuristic, translator)
    @queue.enqueue(Heuristic::Jobs::AddHeuristicToMatchingDocuments, heuristic.id, heuristic.create_search(translator).build_query)
  end

  def heuristic_updated(heuristic, translator)
    @queue.enqueue(Heuristic::Jobs::ReindexMatchingDocuments, heuristic.create_search(translator).build_query)
  end

  def heuristic_destroyed(heuristic, translator)
    @queue.enqueue(Heuristic::Jobs::ReindexMatchingDocuments, heuristic.create_search(translator).build_query)
  end
end

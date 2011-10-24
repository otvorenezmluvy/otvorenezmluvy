require 'spec_helper'

describe DocumentsRepository do
  it "should persist object in db and index" do
    doc = mock(Document)
    index = mock(ElasticRecordIndex)
    repo = DocumentsRepository.new(index)

    doc.should_receive(:save!)
    index.should_receive(:index).with(doc)

    repo.save!(doc)
  end

  it "should index pages after save" do
    doc = Document.new
    pages_repo = mock(PagesRepository)
    index = mock(ElasticRecordIndex)
    repo = DocumentsRepository.new(index, pages_repo)

    pages_repo.should_receive(:index_document_pages).with(doc)

    repo.save!(doc)
  end

  it "should add matching heuristics before save" do
    heuristics = []
    doc = mock(Document)
    index = mock(ElasticRecordIndex)
    heuristics_finder = mock(HeuristicsFinder)
    repo = DocumentsRepository.new(index, heuristics_finder)
    heuristics_finder.should_receive(:find_matching_heuristics).with(doc).returning(heuristics)

    doc.should_receive(:matching_heuristics=).with(heuristics)

    repo.save!(doc)
  end
end

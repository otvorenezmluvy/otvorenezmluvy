require 'spec_helper'

class DocumentWithBogusMapping
  def self.index_settings
    {:mappings => {:page => {:properties => {
        :id => {:type => :int # int is bogus
        }}}}
    }
  end
end

describe ElasticRecordIndex do
  before(:each) do
    @index = ElasticRecordIndex.new(Document, Configuration.index_name, Configuration.elasticsearch)
    @index.delete_index
  end

  it "should recreate index when missing" do
    @index.exists?.should == false

    @index.recreate
    @index.exists?.should == true
  end

  it "should recreate index when exists" do
    @index.recreate
    @index.exists?.should == true
    @index.recreate
  end

  it "should return not raise exception on error deleting missing index" do
    lambda { @index.delete_index }.should_not raise_error
  end

  it "should index document" do
    @index.recreate
    doc = Crz::Document.new(:supplier => "aaa")
    doc.id = 5 # simulate persisted object

    @index.index(doc)
    found = @index.get(5)
    found.should_not be_nil
    found.supplier.should == "aaa"
  end

  it "should delete indexed document" do
    @index.recreate
    doc = Crz::Document.new(:supplier => "aaa")
    doc.id = 5 # simulate persisted object

    @index.index(doc)
    @index.delete(doc)
    @index.get(5).should be_nil
  end

  it "should return matches when percolating" do
    @index.recreate
    query = {:query => {
        :term => {:supplier => 'aaa'}
    }}
    @index.register_percolator(:a_matcher, query)
    @index.percolate(Crz::Document.new(:supplier => "aaa")).should == ['a_matcher']
    @index.percolate(Crz::Document.new(:supplier => "bbb")).should == []
  end

  it "should check if has percolator" do
    @index.recreate
    query = {:query => {
        :term => {:supplier => 'aaa'}
    }}
    @index.has_percolator?(:a_matcher).should == false
    @index.register_percolator(:a_matcher, query)
    @index.has_percolator?(:a_matcher).should == true
  end

  it "should be able to remove percolator by identifier" do
    @index.recreate
    query = {:query => {
        :term => {:supplier => 'aaa'}
    }}
    @index.register_percolator(:a_matcher, query)
    @index.remove_percolator(:a_matcher).should == true
    @index.has_percolator?(:a_matcher).should == false
  end

  it "should not fail when removing nonexistent percolator" do
    @index.recreate
    @index.has_percolator?(:a_matcher).should == false
    @index.remove_percolator(:a_matcher).should == false
  end

  it "should be able to scroll results with find_each" do
    @index.recreate
    data = ['aaa', 'bbb', 'ccc']
    (1..50).each do |i|
      doc = Crz::Document.new(:supplier => data[i % 3])
      doc.id = i # simulate persistence
      @index.index(doc)
    end
    @index.flush

    query = {:query => {
        :term => {:supplier => 'aaa'}
    }}

    fetched = []
    @index.find_each(query) do |document|
      fetched << document
      document.supplier.should == "aaa"
    end

    fetched.collect(&:id).should == [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48]
  end

  it "should be able to find pending updates after flush" do
    @index.recreate
    query = {:query => {:match_all => {}}}

    (1..50).each do |i|
      doc = Crz::Document.new
      doc.id = i # simulate persistence
      @index.index(doc)
    end

    @index.search(query).hits.total.should_not == 50
    @index.flush
    @index.search(query).hits.total.should == 50
  end

  it "should be able to find pending percolator queries after flush" do
    @index.recreate
    query = {:query => {:match_all => {}}}

    (1..50).each do |i|
      @index.register_percolator(i, query)
    end

    @index.total_percolators.should_not == 50
    @index.flush_percolators
    @index.total_percolators.should == 50
  end

  it "should be able to search documents based on query" do
    @index.recreate
    doc = Crz::Document.new(:supplier => "aaa")
    doc.id = 5 # simulate persisted object
    @index.index(doc)

    doc = Crz::Document.new(:supplier => "bbb")
    doc.id = 6 # simulate persisted object
    @index.index(doc)
    @index.flush

    query = {:query => {
        :term => {:supplier => 'aaa'}
    }}

    results = @index.search(query)
    results.hits.total.should == 1
    results.hits.first.supplier.should == "aaa"
  end

  it "should return meaningful exception on failure" do
    @index.recreate
    lambda { @index.search({:bogus => 1}) }.should raise_exception(ElasticRecordIndex::Exception, /Failed to execute phase/)
  end

  it "should fail when creating with invalid mapping" do
    index = ElasticRecordIndex.new(DocumentWithBogusMapping, :bogus, Configuration.elasticsearch)
    lambda { index.recreate }.should raise_error
  end

  it "should be able to reindex all documents" do
    @index.recreate
    doc = Crz::Document.create!(:supplier => "aaa", :crz_id => 1, :identifier => "xyz", :name => "test", :customer => "ibm")
    @index.reindex_all
    @index.get(doc.id).should_not be_nil
  end

  xit "should be able to reindex all documents with fewer queries" do
    @index.recreate
    doc = Crz::Document.create!(:supplier => "aaa", :crz_id => 1, :identifier => "xyz", :name => "test", :customer => "ibm")
    attachment = doc.attachments.create(:crz_doc_id => 1)
    attachment.pages.create(:text => 'aaa', :number => 1)
    @index.reindex_all(:attachments => :pages)
    # TODO how do I test this shit?
  end
end
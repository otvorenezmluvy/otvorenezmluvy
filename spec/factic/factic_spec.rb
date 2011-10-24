require 'spec_helper'

describe Factic do
  before do
    @index = Configuration.documents_repository
    @index.recreate
    doc = Crz::Document.new(
        :supplier => "minio, s.r.o.",
        :customer => "STU Bratislava",
        :published_on => Date.civil(2011, 1, 20),
        :total_amount => 2200.0,
        :crz_id => 1,
        :identifier => 'xxx',
        :name => 'dodavka softveru'
    )
    attachment = doc.attachments.build(:crz_doc_id => 1)
    attachment.pages.build(:number => 1, :text => "minio.sk")
    attachment.pages.build(:number => 2, :text => "test")
    attachment.pages.build(:number => 3, :text => "minio.sk")
    attachment.pages.build(:number => 4, :text => "minio.sk")
    attachment.pages.build(:number => 5, :text => "minio.sk")
    attachment.pages.build(:number => 6, :text => "minio.sk")
    doc.save

    doc = Crz::Document.new(
        :total_amount => 4000.0,
        :published_on => Date.civil(2011, 1, 21),
        :supplier => "varle, s.r.o.",
        :customer => "STU Bratislava",
        :crz_id => 2,
        :identifier => 'yyy',
        :name => 'BIO zelenina'
    )
    attachment = doc.attachments.build(:crz_doc_id => 2)
    attachment.pages.build(:number => 1, :text => "nejake varle")
    doc.save

    @index.flush
  end


  it "should return highlighted results when using fulltext facet" do
    factic = Factic.new(@index, :facets => [
        Factic::FulltextFacet.new(:q, :highlight => [:supplier])
    ])

    results = factic.search(:q => "minio")
    results.hits.total.should == 1
    results.hits.each do |match|
      #match.highlights(:supplier).any?.should == true
      match.highlighted_supplier.should == '<em>minio</em>, s.r.o.'
    end
  end

  it "should return populated terms facet" do
    factic = Factic.new(@index, :facets => [
        Factic::FulltextFacet.new(:q),
        Factic::TermsFacet.new(:supplier)
    ])

    results = factic.search({})

    facet = results.facets[:supplier]
    facet.terms.size.should == 2
    facet.terms.first.term.should == "varle, s.r.o."
    facet.terms.first.search_params.should == {:supplier => "varle, s.r.o."}
    facet.terms.first.selected?.should == false
    facet.terms.first.count.should == 1
    facet.terms.last.term.should == "minio, s.r.o."
    facet.terms.last.search_params.should == {:supplier => "minio, s.r.o."}
    facet.terms.last.selected?.should == false
    facet.terms.last.count.should == 1
  end

  it "should return results sorted by field" do
    factic = Factic.new(@index, :sort_fields => [:total_amount])
    actual_results = factic.search({:sort => :total_amount}).hits
    sorted_results = actual_results.clone.sort_by(&:total_amount).reverse
    actual_results.should == sorted_results

    actual_results = factic.search({:sort => "total_amount"}).hits
    actual_results.should == sorted_results
  end

  it "should only allow sorting by specified fields" do
    factic = Factic.new(@index, :sort_fields => [:total_amount])
    matches = factic.search({}).hits
    bogus_matches = factic.search({:sort => :bogus}).hits
    bogus_matches.should == matches
  end

  it "should extract valid search params from request" do
    factic = Factic.new(@index, :facets => [
        Factic::FulltextFacet.new(:q),
        Factic::TermsFacet.new(:supplier),
        Factic::StatisticalFacet.new(:total_amount)
    ])

    results = factic.search(:q => "minio", :junk => "this is garbage", :total_amount => "special junk")
    results.search_params.should == {:q => "minio"}
  end
end

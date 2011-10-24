require 'spec_helper'

describe Heuristic do
  before(:each) do
    @index = Configuration.documents_repository
    @index.recreate
    @index.flush_percolators
  end

  it "should add points and itself to matching documents after save" do
    Crz::Document.create(:supplier => "minio, s.r.o.", :crz_id => 1, :identifier => "xxx", :name => "bla bla", :customer => "AFP+TIS", :total_amount => 2200.0)
    @index.flush

    heuristic = Heuristic.create(:name => 'Testing', :points => 5, :explanation => 'explanation', :search_parameters => {:supplier => "minio, s.r.o."})

    Crz::Document.find_all_by_supplier("minio, s.r.o.").size.should == 1
    Crz::Document.find_all_by_supplier("minio, s.r.o.").each do |doc|
      doc.points.should == 5
      doc.matching_heuristics.should == [heuristic]
    end
  end

  it "should add points and itself to new documents" do
    heuristic = Heuristic.new(:name => 'Testing', :points => 5, :explanation => 'explanation')
    heuristic.search_parameters = {:supplier => "minio, s.r.o."}
    heuristic.save

    doc = Crz::Document.create!(:supplier => "minio, s.r.o.", :crz_id => 1, :identifier => "xxx", :name => "bla bla", :customer => "AFP+TIS", :total_amount => 2200.0)

    doc.points.should == 5
    doc.matching_heuristics.should == [heuristic]
  end

  it "should find or initialize by search parameters" do
    created = Heuristic.new(:name => 'Testing', :points => 5, :explanation => 'explanation')
    created.search_parameters = {:supplier => "minio, s.r.o."}
    created.save

    found = Heuristic.find_or_initialize_by_search_parameters(:supplier => "minio, s.r.o.")
    found.should == created

    initialized = Heuristic.find_or_initialize_by_search_parameters(:supplier => "varle, s.r.o.")
    initialized.new_record?.should == true
  end

  it "should add itself to percolator on create" do
    heuristic = Heuristic.create(:name => 'Testing', :points => 5, :explanation => 'explanation', :search_parameters => {:supplier => "minio, s.r.o."})
    @index.has_percolator?(heuristic.identifier).should == true
  end

  it "should remove itself from percolator on destroy" do
    heuristic = Heuristic.create(:name => 'Testing', :points => 5, :explanation => 'explanation', :search_parameters => {:supplier => "minio, s.r.o."})
    heuristic.destroy
    @index.has_percolator?(heuristic.identifier).should == false
  end

  it "should reindex matching documents when points are updated" do
    doc = Crz::Document.create(:supplier => "minio, s.r.o.", :crz_id => 1, :identifier => "xxx", :name => "bla bla", :customer => "AFP+TIS", :total_amount => 2200.0)
    @index.flush

    heuristic = Heuristic.create(:name => 'Testing', :points => 5, :explanation => 'explanation', :search_parameters => {:supplier => "minio, s.r.o."})
    heuristic.points = 10
    heuristic.save

    doc.reload
    doc.points.should == 10
    doc.matching_heuristics.should == [heuristic]

    @index.get(doc.id).points.should == 10
  end
end

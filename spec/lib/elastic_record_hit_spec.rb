require 'spec_helper'

describe ElasticRecordIndex::Hit do
  it "should return field from fields data" do
    data = {:fields => {:supplier => "minio"}}.to_openstruct
    hit = ElasticRecordIndex::Hit.new(Document, data)
    hit.supplier.should == "minio"
  end

  it "should return highlighted field and be html safe" do
    data = {:highlight => {:supplier => ["<em>minio</em>, s.r.o."]}}.to_openstruct
    hit = ElasticRecordIndex::Hit.new(Document, data)
    hit.highlighted_supplier.should == "<em>minio</em>, s.r.o."
    hit.highlighted_supplier.html_safe?.should == true
  end

  it "should return unhighlighted field when not a highlight match" do
    data = {:_source => {:supplier => "minio, s.r.o."}}.to_openstruct
    hit = ElasticRecordIndex::Hit.new(Document, data)
    hit.highlighted_supplier.should == "minio, s.r.o."
  end

  it "should return all highlights" do
    data = {:highlight => {:supplier => ["<em>minio</em>, s.r.o."]}}.to_openstruct
    hit = ElasticRecordIndex::Hit.new(Document, data)
    hit.highlights(:supplier).should be_a(Array)
    hit.highlights(:supplier).any?.should == true
  end

  it "should return empty highlights when no matching highlight" do
    data = {:highlight => {:supplier => ["<em>minio</em>, s.r.o."]}}.to_openstruct
    hit = ElasticRecordIndex::Hit.new(Document, data)
    hit.highlights(:bogus).any?.should == false
  end

  it "should return empty highlights when nothing highlighted" do
    data = {:_source => {:supplier => ["<em>minio</em>, s.r.o."]}}.to_openstruct
    hit = ElasticRecordIndex::Hit.new(Document, data)
    hit.highlights(:supplier).any?.should == false
  end

  it "should equal when ids are equal" do
    hit1 = ElasticRecordIndex::Hit.new(Document, {:_id => 5}.to_openstruct)
    hit2 = ElasticRecordIndex::Hit.new(Document, {:_id => 5}.to_openstruct)
    hit3 = ElasticRecordIndex::Hit.new(Document, {:_id => 6}.to_openstruct)
    hit1.should == hit2
    hit1.should_not == hit3
  end

  it "should return id from _id" do
    hit = ElasticRecordIndex::Hit.new(Document, {:_id => '5'}.to_openstruct)
    hit.id.should == 5
  end

  it "should be able to return real underlying object" do
    doc = Crz::Document.create(:supplier => "minio, s.r.o", :crz_id => 1, :identifier => "xxx", :name => "bla bla", :customer => "AFP+TIS")
    hit = ElasticRecordIndex::Hit.new(Document, {:_id => doc.id}.to_openstruct)
    hit.object.should == doc
  end

  it "should raise error when field not found" do
    hit = ElasticRecordIndex::Hit.new(Document, {:_id => 5}.to_openstruct)
    lambda { hit.supplier }.should raise_error(NoMethodError, "Field supplier not loaded into hit, try loading it or use object method to get underlying object")
  end

  it "should return act as AR" do
    hit = ElasticRecordIndex::Hit.new(Document, {:_id => 5}.to_openstruct)
    hit.to_param.should == 5
  end
end

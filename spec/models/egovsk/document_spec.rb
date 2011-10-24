require 'spec_helper'

describe Egovsk::Document do
  it "should return nil on appendixes count" do
    doc = Egovsk::Document.new
    doc.to_indexable.with_indifferent_access[:appendixes_count].should be_nil
  end
end

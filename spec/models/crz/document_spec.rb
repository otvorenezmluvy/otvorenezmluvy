require 'spec_helper'

describe Crz::Document do
  it "should return 0 appendixes when none are found" do
    doc = Crz::Contract.new
    doc.to_indexable.with_indifferent_access[:appendixes_count].should == 0
  end
end

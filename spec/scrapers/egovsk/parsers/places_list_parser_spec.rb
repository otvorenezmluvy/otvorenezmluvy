require 'spec_helper'

describe Egovsk::Parsers::PlacesListParser do
  it "should parse all places" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/places-list-page.html')
    list = Egovsk::Parsers::PlacesListParser.parse(html)
    list.first.should == 117
    list.last.should == 186
  end
end

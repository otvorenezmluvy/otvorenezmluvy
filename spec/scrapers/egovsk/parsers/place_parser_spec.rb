require 'spec_helper'

describe Egovsk::Parsers::PlaceParser do
  it "should parse csv url" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/place.html')
    url = Egovsk::Parsers::PlaceParser.parse(html)
    url.should == "/Egov/contracts/place:223/orderBy:datum/direction:desc/csvExport:156924646313193193511763631808?sessidbe4c74ae4496a63daa027d4d4515897f=3ae3cfb07d4a8cf410bb3844dad0d150"
  end
end




require 'spec_helper'

describe Crz::Parsers::DocumentsListParser do
  it "should parse all info" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contracts-list.html')
    list = Crz::Parsers::DocumentsListParser.parse(html)
    list.contract_ids.first.should == 204569
    list.contract_ids.last.should == 204521
    list.next_page_number.should == 16
  end

  it "should return nil on last page" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contracts-list-last-page.html')
    list = Crz::Parsers::DocumentsListParser.parse(html)
    list.next_page_number.should be_nil
  end
end

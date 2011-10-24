require 'spec_helper'

describe Crz::Parsers::DocumentParser do
  it "should recognize appendix and contract" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-simple.html')
    doc = Crz::Parsers::DocumentParser.parse(html)
    doc.should be_a(Crz::Contract)

    html = File.read(File.dirname(__FILE__) + '/../fixtures/appendix.html')
    doc = Crz::Parsers::DocumentParser.parse(html)
    doc.should be_a(Crz::Appendix)
  end
end

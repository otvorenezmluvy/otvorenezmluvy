require 'spec_helper'

describe Crz::Parsers::ContractParser do
  it "should parse all info" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-simple.html')
    contract = Crz::Parsers::ContractParser.parse(html)
    contract.crz_id.should == 205244
    contract.identifier.should == "41/2011/ZZ"
    contract.name.should == "Dodatok č. 4 k zmluve o spolupráci"
    contract.department.should == "Ministerstvo kultúry SR"
    contract.customer.should == "Knižnica Juraja Fándlyho v Trnave, Trnavský samosprávny kraj"
    contract.supplier.should == "Slovenská národná knižnica"
    contract.supplier_ico.should == 36138517
    contract.note.should == "Náklady: podľa Článku V. tohoto Dodatku"
    contract.published_on.should == Date.civil(2011, 6, 9)
    contract.effective_from.should == Date.civil(2011, 6, 10)
    contract.expires_on.should be_nil
    contract.contracted_amount.should == 0
    contract.total_amount.should == 0
    contract.emitter.should == "Slovenská národná knižnica"
  end

  it "should parse amounts with spaces correctly" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-with-attachments.html')
    contract = Crz::Parsers::ContractParser.parse(html)
    contract.contracted_amount.to_i.should == 96_900
    contract.total_amount.to_i.should == 96_900
  end

  it "should parse weird date correctly" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-invalid-date.html')
    contract = Crz::Parsers::ContractParser.parse(html)
    contract.effective_from.should be_nil
  end

  it "should parse status" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-with-attachments.html')
    contract = Crz::Parsers::ContractParser.parse(html)
    contract.status.should == "Doplnená"
  end

  it "should parse attachments" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-with-attachments.html')
    contract = Crz::Parsers::ContractParser.parse(html)
    contract.attachments.collect(&:number).should == [1, 2]
    contract.attachments.collect(&:crz_doc_id).should == [172189, 172190]
    contract.attachments.collect(&:name).should == ["Zmluva o poskytovaní, odbere a využívaní spravodajského servisu - 1.28 MB", "Zmluva o poskytovaní, odbere a využívaní spravodajského servisu - 1.28 MB"]
  end

  it "should parse appendix connections" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-with-attachments.html')
    contract = Crz::Parsers::ContractParser.parse(html)
    contract.appendix_connections.first.crz_id.should == 173751
  end
end

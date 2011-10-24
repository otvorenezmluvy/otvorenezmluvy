require 'spec_helper'

describe Crz::Parsers::ContractParser do
  it "should parse all info" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/appendix.html')
    contract = Crz::Parsers::AppendixParser.parse(html)
    contract.crz_id.should == 197568
    contract.identifier.should == "XII/73/11/RUK-JLF"
    contract.name.should == "Čiastková zmluva č.6 k rámcovej dohode č.XII/148/10/RUK Tlačiarenské a publikačné služby"
    contract.department.should be_nil
    contract.customer.should == "Univerzita Komenského v Bratialave- Jesseniova lekárska fakulta v Martine"
    contract.supplier.should == "Štatistické a evidenčné vydavateľstvo tlačív, a.s. ŠEVT a.s."
    contract.effective_from.should == Date.civil(2011, 6, 1)
    contract.expires_on.should be_nil
    contract.contracted_amount.should == 1353
    contract.contract_crz_id.should == 120531
  end
end

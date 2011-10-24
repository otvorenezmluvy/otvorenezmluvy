require 'spec_helper'

describe Egovsk::Parsers::JSONParser do

  it "should parse out all info" do
    json = File.read(File.dirname(__FILE__) + '/../fixtures/smizany.json')
    doc = Egovsk::Parsers::JSONParser.parse(ActiveSupport::JSON.decode(json).first)
    doc.class.should == Egovsk::Contract
    doc.name.should == "Licencia PaM, systémová údržba"
    doc.contract_number.should == "ZoD 115/2008/ZODH/PN"
    doc.supplier.should == "Hour, spol. s.r.o."
    doc.supplier_ico.should == 31586163
    doc.total_amount.should == nil
    doc.periodicity.should == "ročne"
    doc.contract_type.should == "dodávateľská"
    doc.valid_from.should == Date.parse("2008-02-28")
    doc.expires_on.should == nil
    doc.signed_on.should == Date.parse("2008-02-28")
    doc.published_on.should == Date.parse("2011-02-23")
    doc.effective_from.should == Date.parse("2011-02-24")
    doc.attachments.first.egovsk_original_url.should == "http://zmluvy.egov.sk/data/MediaLibrary/23/23448/hour0001.pdf"
  end
end


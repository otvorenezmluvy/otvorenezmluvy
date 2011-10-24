require 'spec_helper'

describe Regis::Parsers::RegisParser do
  it "should parse all info of active company" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/minio.html')
    subject = Regis::Parsers::RegisParser.parse(html)
    subject.regis_id.should == 1149061
    subject.ico.should == 46058397
    subject.name.should == "minio, s. r. o."
    subject.address.should == "Šafárikovo námestie 7, 811 02 Bratislava - Staré Mesto"
    subject.created_on.should == Date.parse("26.02.2011")
    subject.dissolved_on.should == nil
    subject.district.should ==  "Bratislava I"
    subject.legal_form_code.should == 112
    subject.legal_form_label.should == "Spoločnosť s ručením obmedzeným"
    subject.sk_nace_category_code.should == 82990
    subject.sk_nace_category_label.should == "Ostatné pomocné obchodné činnosti i. n."
    subject.okec_category_code.should == 74870
    subject.okec_category_label.should == "Ostatné obchodné činnosti i. n."
    subject.sector_code.should == 11002
    subject.sector_label.should == "Súkromné nefinančné korporácie"
    subject.ownership_category_code.should == 2
    subject.ownership_category_label.should == "Súkromné tuzemské"
    subject.organisation_size_category_code.should == 00
    subject.organisation_size_category_label.should == "nezistený počet zamestnacov"
  end

  it "should parse dissolved_on date of non-active company" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/telkor.html')
    subject = Regis::Parsers::RegisParser.parse(html)
    subject.dissolved_on.should == Date.parse("15.11.2005")
    subject.sk_nace_category_code.should == nil
    subject.sk_nace_category_label.should == ""
    subject.organisation_size_category_code.should == nil
    subject.organisation_size_category_label.should == "0-2 zamestnanci"
  end

  it "should return correct url" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/minio.html')
    subject = Regis::Parsers::RegisParser.parse(html)
    subject.url.should == "http://www.statistics.sk/pls/wregis/detail?wxidorg=1149061"
  end
end

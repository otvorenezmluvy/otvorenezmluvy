require 'spec_helper'

describe Crz::Jobs::DownloadDocument do
  before(:each) do
    Resque.redis.flushall
  end

  it "should download contract" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-simple.html')
    FakeWeb.register_uri(:get, "http://www.crz.gov.sk/index.php?ID=205244&l=sk", :body => html)

    Crz::Jobs::DownloadDocument.perform(205244)

    Crz::Contract.first.crz_id.should == 205244
  end

  it "should not download contract when already exists" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-simple.html')
    FakeWeb.register_uri(:get, "http://www.crz.gov.sk/index.php?ID=205244&l=sk", :body => html)
    Factory.create(:crz_contract, :crz_id => 205244)

    Crz::Jobs::DownloadDocument.perform(205244)

    Crz::Contract.first.crz_id.should == 205244
  end


  it "should enqueue attachments and appendix download jobs" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contract-with-attachments.html')
    FakeWeb.register_uri(:get, "http://www.crz.gov.sk/index.php?ID=205244&l=sk", :body => html)

    Crz::Jobs::DownloadDocument.perform(205244)

    Resque.size(:crz).should == 3

    job = Resque.reserve(:crz)
    job.payload_class.should == Crz::Jobs::DownloadAttachment
    job.args.should == [172189]

    Resque.dequeue(Crz::Jobs::DownloadAttachment)

    job = Resque.reserve(:crz)
    job.payload_class.should == Crz::Jobs::DownloadAppendix
    job.args[0].should == 173751
  end
end

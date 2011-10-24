require 'spec_helper'

describe Egovsk::Jobs::DownloadPlacesList do
  before do
    Resque.redis.flushall
  end

  it "should enqueue download jobs" do
    json = File.read(File.dirname(__FILE__) + '/../fixtures/places.json')
    FakeWeb.register_uri(:get, "http://zmluvy.egov.sk/egov/jsonExport", :body => json)

    Egovsk::Jobs::DownloadPlacesList.perform

    Resque.size(:egovsk).should == 117

    job = Resque.reserve(:egovsk)
    job.payload_class.should == Egovsk::Jobs::DownloadJSON
    job.args.count == 2
    job.args[0]['id'].should == "102"
    #job.args[1].should == "AD HOC Malacky, p.o.m."
  end
end

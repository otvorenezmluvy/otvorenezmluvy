require 'spec_helper'

describe Egovsk::Jobs::DownloadJSON do
  before do
    Resque.redis.flushall
  end

  it "should download job" do
    
    json = File.read(File.dirname(__FILE__) + '/../fixtures/smizany.json')
    FakeWeb.register_uri(:get, "http://zmluvy.egov.sk/egov/jsonExport/place:181", :body => json)

    places_json = ActiveSupport::JSON.decode(File.read(File.dirname(__FILE__) + '/../fixtures/places.json'))
    places_json.each do |place|
      if(place["id"] == "181")
        Egovsk::Jobs::DownloadJSON.perform(place,0,nil)
        Egovsk::Contract.first.egovsk_id.should == 257948
      end
    end
  end
end

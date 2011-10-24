require 'spec_helper'

describe Regis::Jobs::DownloadSubject do
  before(:each) do
    Resque.redis.flushall
  end

  it "should download subject" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/minio.html')
    FakeWeb.register_uri(:get, "http://www.statistics.sk/pls/wregis/detail?wxidorg=1149061", :body => html)
    Regis::Jobs::DownloadSubject.perform(1149061)
    Regis::Subject.first.name.should == "minio, s. r. o."
  end

  it "should deal with 404 Not Found" do
    FakeWeb.register_uri(:get, "http://www.statistics.sk/pls/wregis/detail?wxidorg=9999", :body => "The requested URL /pls/wregis/detail was not found on this server.", :status => ["404", "Not Found"])
    Regis::Jobs::DownloadSubject.perform(9999)
  end
end

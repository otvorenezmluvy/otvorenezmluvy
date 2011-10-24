require 'spec_helper'

describe Crz::Jobs::DownloadDocumentsPage do
  before do
    Resque.redis.flushall
  end

  it "should enqueue download jobs" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contracts-list-last-page.html')
    FakeWeb.register_uri(:get, "http://www.crz.gov.sk/index.php?ID=114394&page=0", :body => html)

    Crz::Jobs::DownloadDocumentsPage.perform

    Resque.size(:crz).should == 17

    job = Resque.reserve(:crz)
    job.payload_class.should == Crz::Jobs::DownloadDocument
    job.args[0].should == 114862
  end

  it "should enqueue next page job when available" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contracts-list.html')
    FakeWeb.register_uri(:get, "http://www.crz.gov.sk/index.php?ID=114394&page=0", :body => html)

    Crz::Jobs::DownloadDocumentsPage.perform

    Resque.size(:crz).should == 21

    job = Resque.reserve(:crz)
    job.payload_class.should == Crz::Jobs::DownloadDocumentsPage
    job.args[0].should == 16
  end

  it "should only enqueue contracts that are not yet persisted" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contracts-list.html')
    FakeWeb.register_uri(:get, "http://www.crz.gov.sk/index.php?ID=114394&page=0", :body => html)

    Crz::Contract.create!(:crz_id => 204569, :identifier => 'a', :name => 'tata', :customer => 'ibm', :supplier => 'aj')
    Crz::Contract.create!(:crz_id => 204565, :identifier => 'b', :name => 'mama', :customer => 'tbc', :supplier => 'aj')

    Crz::Jobs::DownloadDocumentsPage.perform

    Resque.size(:crz).should == 19

    Resque.dequeue(Crz::Jobs::DownloadDocumentsPage)

    job = Resque.reserve(:crz)
    job.payload_class.should == Crz::Jobs::DownloadDocument
    job.args[0].should == 204566
  end

  it "should not enqueue next page job if all contracts from page are already downloaded" do
    html = File.read(File.dirname(__FILE__) + '/../fixtures/contracts-list.html')
    FakeWeb.register_uri(:get, "http://www.crz.gov.sk/index.php?ID=114394&page=0", :body => html)

    crz_ids = [204569, 204565, 204566, 204562, 204551, 204554, 204556, 204555, 204552, 204544, 204546, 204547, 204542, 204540, 204538, 204536, 204529, 204532, 204530, 204521]
    crz_ids.each { |crz_id| Crz::Contract.create!(:crz_id => crz_id, :identifier => 'a', :name => 'tata', :customer => 'ibm', :supplier => 'aj') }

    Crz::Jobs::DownloadDocumentsPage.perform

    Resque.size(:crz).should == 0
  end
end

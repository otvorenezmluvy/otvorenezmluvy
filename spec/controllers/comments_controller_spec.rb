require 'spec_helper'

describe CommentsController do
  include Devise::TestHelpers

  before do
    @doc = Crz::Contract.new(
        :supplier => "minio, s.r.o.",
        :customer => "STU Bratislava",
        :published_on => Date.civil(2011, 1, 20),
        :expires_on => Date.civil(2041, 1, 20),
        :total_amount => 2200.0,
        :name => 'dodavka softveru',
        :crz_id => 123,
        :identifier => '795/2011'
    )

    @attachment = @doc.attachments.build(:number => 1)
    @page = @attachment.pages.build(:number => 1, :text => "minio.sk")

    @doc.save!

    @user = User.create(:email => 'eva@afp.sk', :password => 'secret')
    sign_in @user

  end

  it "should create new comment for the particular attachment page if the comment was created from the document editor" do
    post :create, :document_id => @doc.id, :area => {"x" => 127, "y" => 345}, :comment => 'Podozrive', :attachment_number => 1, :page_number => 1

    @page.reload
    @page.comments.count.should == 1
    @page.comments.first.comment.should == "Podozrive"
    @page.comments.first.area.should == '{"x":"127","y":"345"}'
    @page.comments.first.user.email.should == @user.email
  end

  it "should create new comment when the comment was created from the comment form" do
    post :create, :document_id => @doc.id, :comment => { :comment => 'Podozrive' }

    @doc.reload
    @doc.comments.count.should == 1
    @doc.comments.first.comment.should == "Podozrive"
    @doc.comments.first.user.email.should == @user.email
  end

end

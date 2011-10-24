Given /^some indexed documents$/ do
  # TODO find a better way to do this (end-to_end test)
  @index = Configuration.documents_repository
  @index.recreate

  doc = Crz::Document.new(
      :supplier => "minio, s.r.o.",
      :customer => "STU Bratislava",
      :department => "STU BA",
      :published_on => Date.civil(2011, 1, 20),
      :total_amount => 2200.0,
      :crz_id => 1,
      :identifier => 'xxx',
      :name => 'dodavka softveru'
  )
  attachment = doc.attachments.build(:crz_doc_id => 1)
  attachment.pages.build(:number => 1, :text => "minio.sk")
  attachment.pages.build(:number => 2, :text => "test")
  attachment.pages.build(:number => 3, :text => "minio.sk")
  attachment.pages.build(:number => 4, :text => "minio.sk")
  attachment.pages.build(:number => 5, :text => "minio.sk")
  attachment.pages.build(:number => 6, :text => "minio.sk")
  doc.save

  doc = Crz::Document.new(
      :total_amount => 4000.0,
      :published_on => Date.civil(2011, 1, 21),
      :supplier => "varle, s.r.o.",
      :customer => "STU Bratislava",
      :department => "STU BA",
      :crz_id => 2,
      :identifier => 'yyy',
      :name => 'BIO zelenina'
  )
  attachment = doc.attachments.build(:crz_doc_id => 2)
  attachment.pages.build(:number => 1, :text => "nejake varle")
  doc.save

  @index.flush
end

Given /^I am searching for documents$/ do
  visit search_documents_path
end

When /^I am logged in as an admin$/ do
  # TODO
end

When /^I refresh page$/ do
  visit current_url
end

When /^I wait for a while$/ do
  @index.flush
  # TODO wait for resque
end
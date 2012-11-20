class DocumentOpening < ActiveRecord::Base
  belongs_to :document
  belongs_to :user
  attr_accessible :document_id, :user_id
end

require_association 'crz/attachment'
require_association 'egovsk/attachment'

class Attachment < ActiveRecord::Base
  include Document::Archivable

  belongs_to :document
  has_many :pages, :order => :number, :dependent => :destroy

  def path_to_pages(options = {})
    "#{path_to_hardcopy(:directory, options)}/pages"
  end

  def path_to_pages_images(options = {})
    "#{path_to_hardcopy(:directory, options)}/images"
  end

  def as_json(options = nil)
    serializable_hash(:only => [:number, :name], :include => { :pages => { :only => [:number, :scanUrl, :textUrl], :include => { :comments => { :only => [:id, :comment, :area, :created_at], :methods => :author_label} }}})
  end
end

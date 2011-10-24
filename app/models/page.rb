class Page < ActiveRecord::Base
  include Document::Archivable

  belongs_to :attachment
  has_many :comments, :include => :user

  def to_indexable
    serializable_hash(:include => {:attachment => {:only => [:document_id, :number]}})
  end

  def path_to_hardcopy(type, options = {})
    case type
      when :text then File.join(attachment.path_to_pages(options), "#{attachment.base_page_name(type)}_#{number}.txt")
      when :image then File.join(attachment.path_to_pages_images(options), options[:size], "#{attachment.base_page_name(type)}_#{number}.gif")
      else raise "Hardcopy of type '#{type}' does not exist"
    end
  end

  def serializable_hash(options = nil)
    hash = super
    if options and options[:only]
      hash[:scanUrl] = path_to_hardcopy(:image, :relative => true, :size => '1000x') if options[:only].include?(:scanUrl)
      hash[:textUrl] = path_to_hardcopy(:text, :relative => true) if options[:only].include?(:textUrl)
    end
    hash
  end
end

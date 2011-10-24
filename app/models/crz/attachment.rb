class Crz::Attachment < Attachment
  has_one :crz_attachment_detail, :class_name => 'Crz::AttachmentDetail', :dependent => :destroy
  delegate :crz_doc_id, :crz_doc_id=, :crz_text_id, :crz_text_id=,
           :note, :note=, :to => :lazy_detail

  def self.find_or_initialize_by_crz_id(crz_id)
    attachment = joins(:crz_attachment_detail).where(:crz_attachment_details => {:crz_doc_id => crz_id}).first
    attachment ||= new(:crz_doc_id => crz_id)
  end

  def crz_original_url
    "http://www.crz.gov.sk/index.php?ID=603&doc=#{crz_doc_id}"
  end

  def crz_text_url
    if crz_text_id
      "http://www.crz.gov.sk/index.php?ID=603&doc=#{crz_text_id}"
    else
      "http://www.crz.gov.sk/index.php?ID=603&doc=#{crz_doc_id}&text=1"
    end
  end

  def archive_path
    "crz/#{crz_doc_id}/#{crz_doc_id}"
  end

  def base_page_name(type)
    case type
      when :image then crz_doc_id
      when :text  then "#{crz_doc_id}-text"
    end
  end

  def delete_original
    FileUtils.rm(path_to_hardcopy(:original))
  end

  def delete_text
    FileUtils.rm(path_to_hardcopy(:text))
  end

  private
  def lazy_detail
    @cached_detail ||= crz_attachment_detail || build_crz_attachment_detail
  end
end

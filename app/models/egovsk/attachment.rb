class Egovsk::Attachment < Attachment
  has_one :egovsk_attachment_detail, :class_name => 'Egovsk::AttachmentDetail'
  delegate :egovsk_attachment_type,:egovsk_attachment_type=,
           :egovsk_doc_id, :egovsk_doc_id=,
           :egovsk_doc2_id, :egovsk_doc2_id=, :to => :lazy_detail

  attr_accessible :egovsk_attachment_type, :egovsk_doc_id, :egovsk_doc2_id, :name, :number

  def egovsk_original_url
    "http://zmluvy.egov.sk/data/MediaLibrary/#{egovsk_doc_id}/#{egovsk_doc2_id}/#{name}"
  end

  def archive_path
    "egovsk/#{egovsk_doc_id}-#{egovsk_doc2_id}/#{name}"
  end

  def base_page_name(type)
    File.basename(name, File.extname(name))
  end

  private
  def lazy_detail
    @cached_detail ||= egovsk_attachment_detail || build_egovsk_attachment_detail
  end
end

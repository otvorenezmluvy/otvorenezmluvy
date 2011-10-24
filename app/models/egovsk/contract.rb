class Egovsk::Contract < Egovsk::Document
  def appendixes
    Egovsk::Document.joins(:egovsk_document_detail).where(:egovsk_document_details => {:root_contract_number => egovsk_id.to_s})
  end

  def appendixes_count
    appendixes.size
  end

  def appendix?
    false
  end
end

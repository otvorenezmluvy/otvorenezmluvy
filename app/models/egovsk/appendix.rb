class Egovsk::Appendix < Egovsk::Document
  # To change this template use File | Settings | File Templates.
  def appendix?
    true
  end

  def parent_contract
    Egovsk::Contract.joins(:egovsk_document_detail).where(:egovsk_document_details => {:egovsk_id => root_contract_number}).first
  end
end
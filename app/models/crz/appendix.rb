class Crz::Appendix < Crz::Document
  def self.find_all_by_contract_crz_id(crz_id)
    joins(:crz_document_detail).where(:crz_document_details => {:contract_crz_id => crz_id})
  end

  def parent_contract
    Crz::Contract.joins(:crz_document_detail).where(:crz_document_details => {:crz_id => contract_crz_id}).first
  end

  def appendix?
    true
  end
end

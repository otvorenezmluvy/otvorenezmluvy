class Crz::Contract < Crz::Document
  has_many :appendix_connections, :foreign_key => :document_id

  def appendixes
    Crz::Appendix.find_all_by_contract_crz_id(crz_id)
  end

  def appendixes_count
    appendixes.size
  end

  def appendix?
    false
  end
end

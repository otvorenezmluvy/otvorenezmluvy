require_association 'crz/contract'
require_association 'crz/appendix'

class Crz::Document < Contract
  has_one :crz_document_detail, :class_name => 'Crz::DocumentDetail'

  delegate :crz_id, :crz_id=, :identifier, :identifier=, :department, :department=,
           :total_amount, :total_amount=, :contracted_amount, :contracted_amount=,
           :customer, :customer=, :supplier, :supplier=, :supplier_ico, :supplier_ico=, :note, :note=,
           :published_on, :published_on=, :effective_from, :effective_from=, :expires_on, :expires_on=,
           :emitter, :emitter=, :contract_crz_id, :contract_crz_id=, :status, :status=, :regis_supplier,
           :to => :lazy_detail

  def original_url
    "http://www.crz.gov.sk/index.php?ID=#{crz_id}&l=sk"
  end

  def self.find_all_by_crz_id(crz_ids)
    joins(:crz_document_detail).where(:crz_document_details => {:crz_id => crz_ids})
  end

  def lazy_detail
    @cached_detail ||= crz_document_detail || build_crz_document_detail
  end

  def source
    "www.crz.gov.sk"
  end
end

class Egovsk::Document < Contract
  #TODO: try moving this to superclass
  has_many :attachments, :autosave => true
  has_one :egovsk_document_detail, :class_name => 'Egovsk::DocumentDetail', :autosave => true

  delegate :egovsk_id, :egovsk_id=,                        #"odkaz na detail"
           :total_amount, :total_amount=,                 #"cena"
           :customer_id, :customer_id=,                   #place_id in zmluvy.egov.sk
           :customer, :customer=,
           :founder, :founder=,
           :supplier, :supplier=,                         #"partner názov"
           :supplier_ico, :supplier_ico=,                 #"partner IČO"
           :note, :note=,                                 #"poznámka"
           :signed_on, :signed_on=,                       #"dátum podpisu"
           :published_on, :published_on=,                 #"dátum zverejnenia"
           :effective_from, :effective_from=,             #"dátum účinnosti"
           :valid_from, :valid_from=,                     #"platnosť od"
           :expires_on, :expires_on=,                     #"platnosť do"
           :contract_number, :contract_number=,           #"číslo zmluvy"
           :root_contract_number, :root_contract_number=, #"číslo pôvodnej zmluvy" (len appendix)
           :contract_type, :contract_type=,               #"druh zmluvy"
           :periodicity, :periodicity=,                   #"periodicita"
           :regis_supplier,
           :to => :lazy_detail

  attr_accessible :egovsk_attachment_type, :egovsk_doc_id, :egovsk_doc2_id, :name, :number,
                  :supplier

  def original_url
    "http://zmluvy.egov.sk/Egov/detail/id:#{egovsk_id}"
  end

  def self.find_all_by_egovsk_id(egovsk_ids)
    includes(:egovsk_document_detail).where(:egovsk_document_details => {:egovsk_id => egovsk_ids})
  end

  def lazy_detail
    @cached_detail ||= egovsk_document_detail || build_egovsk_document_detail
  end

  def source
    "zmluvy.egov.sk"
  end
end

require_association 'egovsk/contract'
require_association 'egovsk/appendix'


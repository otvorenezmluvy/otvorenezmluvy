# encoding: utf-8
class Contract < Document
  has_many :attachments, :foreign_key => :document_id

  def title
    name_or_unknown = name || "Dokument bez uvedeného názvu"
    [name_or_unknown, customer, supplier].compact.join(', ')
  end

  def supplier_age
    (published_on - regis_supplier.created_on).to_i if regis_supplier
  end

  def legal_form
    regis_supplier.legal_form_label if regis_supplier
  end

  def ownership_category
    regis_supplier.ownership_category_label if regis_supplier
  end

  def supplier_nace
    regis_supplier.sk_nace_category_label if regis_supplier
  end

  def attachments_count
    attachments.size
  end

  def total_pages_count
    attachments.collect(&:pages).flatten.size
  end
end

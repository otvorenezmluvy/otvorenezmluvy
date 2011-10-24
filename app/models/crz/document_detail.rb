class Crz::DocumentDetail < ActiveRecord::Base
  has_many :appendixes, :class_name => 'Crz::Appendix', :foreign_key => :crz_id, :primary_key => :contract_crz_id
  belongs_to :regis_supplier, :class_name => "Regis::Subject", :foreign_key => :supplier_ico, :primary_key => :ico
end

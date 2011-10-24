class Egovsk::DocumentDetail < ActiveRecord::Base
  belongs_to :regis_supplier, :class_name => "Regis::Subject", :foreign_key => :supplier_ico, :primary_key => :ico
end

class ChangeEgovskIcoToBigint < ActiveRecord::Migration
  def change
    change_column(:egovsk_document_details, :supplier_ico, :bigint)
  end

end

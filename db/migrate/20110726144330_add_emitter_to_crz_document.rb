class AddEmitterToCrzDocument < ActiveRecord::Migration
  def change
    add_column :documents, :emitter, :string
  end
end

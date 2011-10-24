class ChangeDocumentNameToText < ActiveRecord::Migration
  def up
    change_column(:documents,:name, :string, :limit => 1000)
  end

  def down
    change_column(:documents,:name, :string)
  end
end

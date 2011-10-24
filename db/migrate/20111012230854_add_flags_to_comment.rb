class AddFlagsToComment < ActiveRecord::Migration
  def up
    add_column(:comments, :flags, :integer, :default => 0)
    add_column(:comments, :mail_sent, :boolean, :default => false)

    s = SpaceshipSetting.new(:label => "Minimálny počet flagov pre komentár", :value => 3 )
    s.identifier = "flagged_comment_threshold"
    s.save
  end

  def down
    remove_column(:comments, :flags)
    remove_column(:comments, :mail_sent)
  end
end

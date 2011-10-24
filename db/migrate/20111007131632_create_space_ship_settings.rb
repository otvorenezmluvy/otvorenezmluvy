class CreateSpaceShipSettings < ActiveRecord::Migration
  def up
    create_table :spaceship_settings do |t|
      t.string :identifier
      t.string :label
      t.integer :value
    end

    s = SpaceshipSetting.new(:label => "Minimálny počet bodov pre najnovšie zmluvy", :value => 3 )
    s.identifier = "recent_min_points"
    s.save

    s = SpaceshipSetting.new(:label => "Časové okno pre najnovšie zmluvy (počet dní dozadu)", :value => 7 )
    s.identifier = "recent_days"
    s.save

    s = SpaceshipSetting.new(:label => "Minimálny počet bodov pre podozrivé zmluvy (štatistika na titulke)", :value => 5 )
    s.identifier = "suspicious_min_points"
    s.save
  end
  def down
    drop_table :spaceship_settings
  end
end

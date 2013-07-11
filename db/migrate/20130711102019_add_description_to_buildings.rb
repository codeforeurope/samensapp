class AddDescriptionToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :description, :text
  end
end

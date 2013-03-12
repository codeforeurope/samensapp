class AddRoomsToBuildings < ActiveRecord::Migration
  def change
    add_column :rooms, :building_id, :integer
    rename_column :buildings, :adress, :address
  end
end

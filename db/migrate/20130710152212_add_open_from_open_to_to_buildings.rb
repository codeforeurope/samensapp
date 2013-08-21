class AddOpenFromOpenToToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :open_from, :time
    add_column :buildings, :open_to, :time
  end
end

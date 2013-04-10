class AddRentableToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :rentable, :boolean
  end
end

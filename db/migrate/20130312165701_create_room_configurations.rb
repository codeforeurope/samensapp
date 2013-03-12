class CreateRoomConfigurations < ActiveRecord::Migration
  def change
    create_table :room_configurations do |t|
      t.integer :room_id
      t.string :name
      t.integer :capacity

      t.timestamps
    end
  end
end

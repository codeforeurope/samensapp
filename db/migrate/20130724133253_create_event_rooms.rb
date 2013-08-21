class CreateEventRooms < ActiveRecord::Migration
  def change
    create_table :event_rooms do |t|
      t.integer :event_id
      t.integer :room_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end

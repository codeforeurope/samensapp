class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :start_at
      t.string :end_at
      t.references :booking_request
      t.references :room
      t.references :room_configuration

      t.timestamps
    end
    add_index :events, :booking_request_id
    add_index :events, :room_id
    add_index :events, :room_configuration_id
  end
end

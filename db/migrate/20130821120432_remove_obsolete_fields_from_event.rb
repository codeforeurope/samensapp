class RemoveObsoleteFieldsFromEvent < ActiveRecord::Migration
  def up
    remove_column :events, :start_at
    remove_column :events, :end_at
    remove_column :events, :room_id
    remove_column :events, :room_configuration_id

  end

  def down
    add_column :events, :start_at, :string
    add_column :events, :end_at, :string
    add_column :events, :room_id, :integer
    add_column :events, :room_configuration_id, :integer
    add_index "events", ["room_configuration_id"], :name => "index_events_on_room_configuration_id"
    add_index "events", ["room_id"], :name => "index_events_on_room_id"
  end
end

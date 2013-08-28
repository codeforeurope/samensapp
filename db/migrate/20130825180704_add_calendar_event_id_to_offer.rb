class AddCalendarEventIdToOffer < ActiveRecord::Migration
  def change
    add_column :event_rooms, :calendar_event_id, :string
  end
end

class AddCalendarToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :google_calendar, :string
  end
end

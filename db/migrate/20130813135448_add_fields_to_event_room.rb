class AddFieldsToEventRoom < ActiveRecord::Migration
  def change
    add_column :event_rooms, :tariff, :string
    add_column :event_rooms, :price, :decimal, :default => 0.0
    add_column :event_rooms, :units, :integer, :default => 1
  end
end

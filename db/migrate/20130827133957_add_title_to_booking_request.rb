class AddTitleToBookingRequest < ActiveRecord::Migration
  def change
    add_column :booking_requests, :title, :string
  end
end

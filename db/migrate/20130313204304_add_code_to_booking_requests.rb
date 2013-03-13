class AddCodeToBookingRequests < ActiveRecord::Migration
  def change
    add_column :booking_requests, :code, :string
    add_index :booking_requests, :code
  end
end

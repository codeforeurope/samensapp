class AddWebsiteToBookingRequest < ActiveRecord::Migration
  def change
    add_column :booking_requests, :website, :string
  end
end

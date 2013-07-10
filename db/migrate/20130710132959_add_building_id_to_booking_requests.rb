class AddBuildingIdToBookingRequests < ActiveRecord::Migration
  def change
    add_column(:booking_requests, :building_id, :integer )
  end
end

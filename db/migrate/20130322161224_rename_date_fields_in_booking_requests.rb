class RenameDateFieldsInBookingRequests < ActiveRecord::Migration
  def change
    rename_column :booking_requests, :start_time, :start_at
    rename_column :booking_requests, :end_time, :end_at
  end

end

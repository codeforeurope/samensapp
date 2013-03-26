class CreateBookingStatuses < ActiveRecord::Migration
  def change
    create_table :booking_statuses do |t|
      t.string :description
      t.integer :booking_request_id

      t.timestamps
    end
  end
end

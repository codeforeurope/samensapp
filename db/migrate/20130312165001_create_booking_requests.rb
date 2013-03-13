class CreateBookingRequests < ActiveRecord::Migration
  def change
    create_table :booking_requests do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :people
      t.text :description
      t.text :catering_needs
      t.text :equipment_needs
      t.text :notes
      t.string :status
      t.integer :submitter_id
      t.integer :assignee_id
      t.timestamps
    end
  end
end

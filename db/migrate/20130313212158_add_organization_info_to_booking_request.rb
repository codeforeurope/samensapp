class AddOrganizationInfoToBookingRequest < ActiveRecord::Migration
  def change
    add_column :booking_requests, :organization_name, :string
    add_column :booking_requests, :contact_person, :string
    add_column :booking_requests, :contact_email, :string
    add_column :booking_requests, :contact_phone, :string
    add_column :booking_requests, :organization_address, :text

  end
end

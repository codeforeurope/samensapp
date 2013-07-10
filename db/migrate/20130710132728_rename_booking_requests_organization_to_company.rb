class RenameBookingRequestsOrganizationToCompany < ActiveRecord::Migration
  def up
    rename_column :booking_requests, :organization_name, :company_name
    rename_column :booking_requests, :organization_address, :company_address
  end

  def down
    rename_column :booking_requests, :company_name, :company_name
    rename_column :booking_requests, :company_address, :company_address
  end
end

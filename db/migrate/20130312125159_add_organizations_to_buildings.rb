class AddOrganizationsToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :organization_id, :integer
  end
end

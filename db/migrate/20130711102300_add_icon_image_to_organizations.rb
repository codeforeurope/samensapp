class AddIconImageToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :icon, :string
    add_column :organizations, :image, :string
  end
end

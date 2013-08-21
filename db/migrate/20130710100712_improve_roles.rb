class ImproveRoles < ActiveRecord::Migration
  def change
    add_column :roles, :authorizable_type, :string
    add_column :roles, :authorizable_id, :integer
  end

end

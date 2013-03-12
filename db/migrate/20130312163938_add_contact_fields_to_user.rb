class AddContactFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone, :string
    add_column :users, :mobile_phone, :string
    add_column :users, :address, :text
  end
end

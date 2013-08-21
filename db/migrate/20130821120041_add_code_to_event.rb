class AddCodeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :status, :string
    add_column :events, :code, :string
    add_index :events, :code
  end
end

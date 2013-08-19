class AddMinimumBlockToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :minimum_block, :integer, :default => 1, :min => 1
  end
end

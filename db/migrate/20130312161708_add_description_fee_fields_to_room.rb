class AddDescriptionFeeFieldsToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :cleaning_fee, :decimal
  end
end

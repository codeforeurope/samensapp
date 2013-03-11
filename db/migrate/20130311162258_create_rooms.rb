class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :floor
      t.decimal :base_price
      t.decimal :blind_price
      t.integer :capacity
      t.text    :description
      t.text    :notes
      t.timestamps
    end
  end
end

class CreateEventCharges < ActiveRecord::Migration
  def change
    create_table :event_charges do |t|
      t.string :name
      t.decimal :price, :decimal, :precision => 6, :scale => 2, :default => 0.00
      t.integer :units, :min => 1, :default => 1
      t.references :event

      t.timestamps
    end
    add_index :event_charges, :event_id
  end
end

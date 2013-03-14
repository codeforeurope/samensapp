class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :description
      t.string :image
      t.integer :attachable_picture_id
      t.string :attachable_picture_type

      t.timestamps
    end
  end
end

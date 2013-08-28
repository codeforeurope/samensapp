class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.references :user
      t.string :token
      t.string :secret
      t.string :name
      t.string :link
      t.integer :expires_at

      t.timestamps
    end
    add_index :authorizations, :user_id
    add_index :authorizations, :token
    add_index :authorizations, :provider
    add_index :authorizations, [:token,:uid]
    add_index :authorizations, [:provider,:uid]

  end
end

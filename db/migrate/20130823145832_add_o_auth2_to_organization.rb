class AddOAuth2ToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :google_token, :string
    add_column :organizations, :google_token_expires_at, :integer
  end
end

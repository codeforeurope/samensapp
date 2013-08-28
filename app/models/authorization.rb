class Authorization < ActiveRecord::Base
  belongs_to :user
  attr_accessible :expires_at, :link, :name, :provider, :secret, :token, :uid
end

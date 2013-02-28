class Role < ActiveRecord::Base
  NAMES = %w"admin booking"
  attr_accessible :name, :user_id
end

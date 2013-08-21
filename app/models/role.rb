class Role < ActiveRecord::Base
  NAMES = %w"global_admin admin booking member"
  attr_accessible :name, :user_id, :authorizable
  belongs_to :authorizable, :polymorphic => true
end

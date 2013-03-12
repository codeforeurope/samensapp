class Building < ActiveRecord::Base
  attr_accessible :adress, :name
  belongs_to :organization
end

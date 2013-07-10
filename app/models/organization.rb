class Organization < ActiveRecord::Base
  attr_accessible :address, :name
  has_many :buildings
  has_many :roles, :as => :authorizable
  has_many :members, :through => :roles, :source => :user, :conditions => "name = 'member'"
  has_many :booking_agents, :through => :roles, :source => :user, :conditions => "name = 'booking'"
  has_many :admins, :through => :roles, :source => :user, :conditions => "name = 'admin'"
end

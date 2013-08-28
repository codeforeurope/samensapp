class Organization < ActiveRecord::Base
  STATUSES = %w"unverified verified inactive"

  include ImageModel
  mount_uploader :image, OrganizationImageUploader
  mount_uploader :icon, OrganizationImageUploader

  attr_accessible :address, :name, :image, :icon, :status, :description, :email, :google_token, :google_refresh_token, :google_token_expires_at

  #for cropping to certain proportions
  attr_accessible :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  has_many :buildings
  has_many :roles, :as => :authorizable
  has_many :members, :through => :roles, :source => :user, :conditions => "name = 'member'"
  has_many :booking_agents, :through => :roles, :source => :user, :conditions => "name = 'booking'"
  has_many :admins, :through => :roles, :source => :user, :conditions => "name = 'admin'"

  before_create :set_default_status
  validates_presence_of :name, :email, :address

  def set_default_status
    self.status = STATUSES[0] #unverified
  end

end

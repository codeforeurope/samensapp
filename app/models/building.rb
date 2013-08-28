#This is the building eg: Meevaart
class Building < ActiveRecord::Base
  attr_accessible :address, :name, :open_from, :open_to, :organization_id, :description
  belongs_to :organization
  has_many :rooms

  geocoded_by :address
  acts_as_gmappable :process_geocoding => false
  after_validation :geocode

  def gmaps4rails_infowindow
    "<h4>#{self.name}</h4>"
  end

  validates_presence_of :name, :address, :organization_id
end

class Room < ActiveRecord::Base
	attr_accessible :minimum_block, :google_calendar, :base_price, :blind_price, :capacity, :floor, :name, :description, :cleaning_fee, :pictures_attributes, :notes, :building_id, :rentable
	belongs_to :building
	has_many :pictures, as: :attachable_picture, :dependent => :destroy
	#accepts_nested_attributes_for :pictures
	has_many :room_configurations
  has_many :event_rooms
  has_many :events, :through => :event_rooms
  validates_presence_of :name, :floor, :base_price, :blind_price, :cleaning_fee, :description, :building_id

  def max_capacity
    self.room_configurations.maximum(:capacity)
  end
end

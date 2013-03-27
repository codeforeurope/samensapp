class RoomConfiguration < ActiveRecord::Base
  attr_accessible :capacity, :name, :room_id
	validates_presence_of :capacity, :name
	belongs_to :room
end

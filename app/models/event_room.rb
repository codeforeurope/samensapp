class EventRoom < ActiveRecord::Base
  include ::Dated
  validates_presence_of :room_id, :event_date, :start_time, :end_time, :price, :units
  attr_accessible :room_id, :start_at, :building_id, :event_date, :start_time, :end_time, :tariff, :price, :units
  attr_accessor :building_id
  attr_writer :sub_total, :available_rooms
  belongs_to :event
  belongs_to :room

  def sub_total
    @sub_total ||= (price * units)
  end

  def available_rooms
    @available_rooms ||= []
  end
end

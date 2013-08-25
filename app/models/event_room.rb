class EventRoom < ActiveRecord::Base
  include ::Dated
  validates_presence_of :room_id, :event_date, :start_time, :end_time, :price, :units
  attr_accessible :room_id, :start_at, :building_id, :event_date, :start_time, :end_time, :tariff, :price, :units
  attr_writer :sub_total, :available_rooms, :building_id
  belongs_to :event
  belongs_to :room

  def sub_total
    @sub_total ||= (price * units)
  end

  def available_rooms
    @available_rooms ||= []
  end

  def building_id
    @building_id ||= (room.building.id if  room.present?)
  end

  def to_google_calendar_json
    output = {
        :summary => "[option] #{event.name}",
        #'location' => 'Somewhere',
        :start => {
            :dateTime => start_at.to_datetime
        },
        :end => {
            :dateTime => end_at.to_datetime
        }
    }
    JSON.dump(output)
  end
end

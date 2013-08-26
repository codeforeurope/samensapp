class EventRoom < ActiveRecord::Base
  include ::Dated

  validates_presence_of :room_id, :event_date, :start_time, :end_time, :price, :units, :calendar_event_id
  attr_accessible :room_id, :start_at, :building_id, :event_date, :start_time, :end_time, :tariff, :price, :units
  attr_writer :sub_total, :available_rooms, :building_id
  belongs_to :event
  belongs_to :room
  delegate :building, :to => :room
  delegate :organization, :to => :building


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

    # need to add the right timezone here
    output = {
        :start => {
            :dateTime => start_at.to_datetime
        },
        :end => {
            :dateTime => end_at.to_datetime
        }
    }
    output[:summary] = (event.status != :accepted.to_s ? "[option] " : "") + "#{event.name}"
    #output[:status] = (event.status == :accepted.to_s ? "confirmed" : "tentative")
    #output[:transparency] = (event.status == :accepted.to_s ? "opaque" : "transparent")
    JSON.dump(output)
  end

  def update_calendar_event(calendar_event)
    calendar_event.start.date_time =start_at.to_datetime
    calendar_event.end.date_time =end_at.to_datetime
    calendar_event.summary = (event.status != :accepted.to_s ? "[option] " : "") + "#{event.name}"
    calendar_event
  end
end



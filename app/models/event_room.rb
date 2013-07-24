class EventRoom < ActiveRecord::Base
  attr_accessible :end_at, :event_id, :room_id, :start_at

  belongs_to :event
  belongs_to :room
end

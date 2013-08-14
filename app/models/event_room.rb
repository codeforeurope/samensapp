class EventRoom < ActiveRecord::Base
  include ::Dated

  attr_accessible :end_at, :event_id, :room_id, :start_at, :building
  attr_accessor :building
  attr_writer :sub_total
  belongs_to :event
  belongs_to :room

  def sub_total
    @sub_total ||= (price * units)
  end
end

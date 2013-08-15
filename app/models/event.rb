class Event < ActiveRecord::Base
  belongs_to :booking_request
  attr_accessible :end_at, :name, :start_at, :room_total
  attr_writer :room_total
  has_many :event_rooms
  has_many :rooms, :through => :event_rooms

  validates :end_at, :presence => true
  validates :name, :presence => true
  validates :start_at, :presence => true
  validates :rooms, :presence => true

  accepts_nested_attributes_for :event_rooms, :allow_destroy => true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  def room_total
    if @room_total.blank?
      @room_total = 0
      event_rooms.each do |event_room|
        @room_total += event_room.sub_total || 0
      end
    end
    @room_total
  end
end

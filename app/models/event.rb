class Event < ActiveRecord::Base
  belongs_to :booking_request
  attr_accessible :end_at, :name, :event_charges, :event_charges_attributes, :event_rooms, :event_rooms_attributes
  attr_writer :room_total, :extras_total, :grand_total
  has_many :event_rooms
  has_many :rooms, :through => :event_rooms
  has_many :event_charges

  validates :name, :presence => true

  accepts_nested_attributes_for :event_rooms, :allow_destroy => true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  accepts_nested_attributes_for :event_charges, :allow_destroy => true

  after_create :update_request_status

  def room_total
    if @room_total.blank?
      @room_total = 0.00
      event_rooms.each do |event_room|
        @room_total += event_room.sub_total || 0.00
      end
    end
    @room_total
  end

  def extras_total
    if @extras_total.blank?
      @extras_total = 0.00
      event_charges.each do |charge|
        @extras_total += charge.total || 0.00
      end
    end
    @extras_total
  end

  def grand_total
    @grand_total ||= room_total + extras_total
  end

  private
  def update_request_status
    booking_request.update_attribute :status, :completed
  end
end

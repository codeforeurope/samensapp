class Event < ActiveRecord::Base
  STATUSES = %w"new sent canceled accepted declined"
  belongs_to :booking_request
  attr_accessible :name, :event_charges, :event_charges_attributes, :event_rooms, :event_rooms_attributes
  attr_writer :room_total, :extras_total, :grand_total
  has_many :event_rooms, :dependent => :destroy
  has_many :rooms, :through => :event_rooms
  has_many :event_charges, :dependent => :destroy

  validates :name, :presence => true

  accepts_nested_attributes_for :event_rooms, :allow_destroy => true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  accepts_nested_attributes_for :event_charges, :allow_destroy => true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }


  before_create :create_code
  before_create :set_default_status
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

  def create_code
    self.code = Devise.friendly_token
  end

  #def set_status
  #  unless self.status == "submitted" and !self.assignee_id.nil? and event.empty?
  #    self.status = STATUSES[1] #assigned
  #  end
  #
  #end

  def set_default_status
    self.status = :new
  end

end

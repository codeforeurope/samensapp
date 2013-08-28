class Event < ActiveRecord::Base
  include ::GoogleCalendar
  STATUSES = %w"new sent canceled accepted declined"
  EXPIRATION_HOURS =  48
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


  before_update :add_to_google_calendar
  before_update :update_in_google_calendar
  before_update :delete_from_google_calendar

  def expired?
    expired_by > 0
  end

  def expired_by
    (Time.now - updated_at)/1.hour - EXPIRATION_HOURS
  end

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

  def self.sent(user)
    joins(:booking_request).where("booking_requests.building_id IN (?) AND events.status = 'sent'", user.buildings).order('events.updated_at ASC')

  end

  def self.confirmed(user)
    joins(:booking_request).where("booking_requests.building_id IN (?) AND (events.status = 'accepted')", user.buildings).order('events.updated_at ASC')

  end

  protected

  def not_yet_sent?
    changed_attributes["status"] == "new" && status == :sent
  end

  def delete_from_google_calendar
    event_rooms.each do |event_room|
      if event_room.organization.google_refresh_token.present? && [:declined, :canceled].include?(status)
        client = calendar_client(event_room.organization)
        result = client.execute(:api_method => calendar_api(event_room.organization).events.delete,
                                :parameters => {:calendarId => event_room.room.google_calendar, :eventId => event_room.calendar_event_id},
                                :headers => {'Content-Type' => 'application/json'})
      end
    end
  end

  def update_in_google_calendar
    event_rooms.each do |event_room|
      if event_room.organization.google_refresh_token.present? && ![:declined, :canceled].include?(status) && !not_yet_sent?
        client = calendar_client(event_room.organization)
        result = client.execute(:api_method => calendar_api(event_room.organization).events.get,
                                :parameters => {:calendarId => event_room.room.google_calendar, :eventId => event_room.calendar_event_id})

        calendar_event = event_room.update_calendar_event result.data, self

        result = client.execute(:api_method => calendar_api(event_room.organization).events.update,
                                :parameters => {:calendarId => event_room.room.google_calendar, :eventId => event_room.calendar_event_id},
                                :body_object => calendar_event,
                                :headers => {'Content-Type' => 'application/json'})
        unless result.status >= 200 && result.status < 300
          errors.add(:base, :unable_to_save_event_in_calendar)
        end
      end
    end
  end


  def add_to_google_calendar
    event_rooms.each do |event_room|
      if event_room.organization.google_refresh_token.present? && not_yet_sent?
        client = calendar_client(event_room.organization)
        result = client.execute(:api_method => calendar_api(event_room.organization).events.insert,
                                :parameters => {:calendarId => event_room.room.google_calendar},
                                :body => event_room.to_google_calendar_json,
                                :headers => {'Content-Type' => 'application/json'})
        if result.status >= 200 && result.status < 300
          event_room.calendar_event_id = result.data.id
        else
          # TODO: handle errors better
          errors.add(:base, :unable_to_save_event_in_calendar)
        end
      end
    end
  end
end

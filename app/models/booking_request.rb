class BookingRequest < ActiveRecord::Base
  include ActiveModel::Validations
  STATUSES = %w"submitted assigned canceled completed"
  attr_accessible :catering_needs, :description, :equipment_needs, :notes, :people, :submitter_id,
                  :company_name, :contact_person, :contact_email, :contact_phone, :company_address,
                  :start_time, :end_time, :event_date, :submitter_attributes, :website

  #attr_accessor :start_time, :end_time, :event_date
  #attr_writer :event_date

  before_create :create_code
  before_create :set_default_status

  #TODO 2013-03-25
  #before_update if assignee is set and it's submitted, then set to assigned
  before_update :set_status

  belongs_to :submitter, :class_name => 'User', :foreign_key => :submitter_id
  belongs_to :booking_agent, :class_name => 'User', :foreign_key => :assignee_id
  has_many :events

  accepts_nested_attributes_for :submitter

  validates_presence_of :submitter, :catering_needs, :description, :equipment_needs, :people
  validates_presence_of :contact_email, :contact_person, :contact_phone, :company_address
  validates_associated :submitter, :on => :create
  validates :people, :numericality => { :greater_than_or_equal_to => 0 }
  validates :website, :allow_blank => true, :url => true


  def start_time
    @start_time || time_attr_from_datetime(start_at)
  end

  def start_time=(start_time_value)
    @start_time = start_time_value
    set_start_at
  end

  def end_time
    @end_time || time_attr_from_datetime(end_at)
  end

  def end_time=(end_time_value)
    @end_time =end_time_value
    set_end_at
  end

  def event_date
    @event_date || (start_at.to_date.to_s(:db) if start_at)
  end

  def event_date=(event_date_value)
    @event_date = event_date_value
    set_start_at
    set_end_at
  end

  def start_at=(start_at_value)
    write_attribute(:start_at, start_at_value) # Maybe you need to do write_attribute(:start_at, DateTime.parse(start_at_value)) here ???
    @start_time = time_attr_from_datetime(start_at)
  end

  def end_at=(end_at_value)
    write_attribute(:end_at, end_at_value) # Maybe you need to do write_attribute(:end_at, DateTime.parse(end_at_value)) here ???
    @end_time = time_attr_from_datetime(end_at)
  end

  private
  def set_start_at
    if (self.start_time)
      self.start_at = Time.zone.parse("#{event_date} #{start_time}:00")
    end
  end

  def set_end_at
    if (self.end_time)
      self.end_at = Time.zone.parse("#{event_date} #{end_time}:00")
    end
  end

  def time_attr_from_datetime(datetime)
    if (datetime)
      "#{'%02d' % datetime.hour}:#{'%02d' % datetime.min}"
    end
  end

  def create_code
    self.code = Devise.friendly_token
  end

  def set_default_status
    self.status = STATUSES[0]
  end

  def set_status
    if self.status == "submitted" and !self.assignee_id.nil?
      self.status = STATUSES[1]
    end
  end

  def self.grouped_by_day(start)
    booking_requests = unscoped.where(created_at: start.beginning_of_day..Time.zone.now)
    booking_requests = booking_requests.group('date(created_at)')
    booking_requests = booking_requests.order('date(created_at)')
    booking_requests = booking_requests.select('date(created_at) as created_at, count(*) as count')
    booking_requests.each_with_object({}) do |request, counts|
      counts[request.created_at.to_date] = request.count
    end
  end

end



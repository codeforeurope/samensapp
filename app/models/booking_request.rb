class BookingRequest < ActiveRecord::Base
  attr_accessible :catering_needs, :description, :equipment_needs, :notes, :people, :submitter_id,
                  :organization_name, :contact_person, :contact_email, :contact_phone, :organization_address, :start_time, :end_time, :event_date

  #attr_accessor :start_time, :end_time, :event_date
  #attr_writer :event_date

  before_create :create_code
  belongs_to :submitter, :class_name => 'User', :foreign_key => :submitter_id
  belongs_to :booking_agent, :class_name => 'User', :foreign_key => :assignee_id
  #has_many :events

  accepts_nested_attributes_for :submitter

  validates_presence_of :submitter, :catering_needs, :description, :end_time, :equipment_needs, :people, :start_time
  validates_presence_of :contact_email, :contact_person, :contact_phone, :organization_address
  validates_associated :submitter


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
    @event_date
    #|| start_at.to_date.to_s(:db)
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

end

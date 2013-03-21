class BookingRequest < ActiveRecord::Base
  attr_accessible :catering_needs, :description, :end_time, :equipment_needs, :notes, :people, :start_time, :submitter_id,
                  :organization_name, :contact_person, :contact_email, :contact_phone, :organization_address

  before_create :create_code
  belongs_to :submitter, :class_name => 'User', :foreign_key => :submitter_id
  belongs_to :booking_agent, :class_name => 'User', :foreign_key => :assignee_id
  #has_many :events

  accepts_nested_attributes_for :submitter

  validates_presence_of :submitter, :catering_needs, :description, :end_time, :equipment_needs, :people, :start_time
  validates_presence_of :contact_email, :contact_person, :contact_phone, :organization_address
  validates_associated :submitter
  #validate :validate_submitter
  private

  def create_code
    self.code = Devise.friendly_token
  end

  def event_date
    self.start_time
  end

  def event_date=(value)

  end

  def begin
    self.start_time
  end

  def begin=(value)

  end

  def end
    self.end_time
  end

  def end=(value)

  end

end

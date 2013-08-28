class BookingRequest < ActiveRecord::Base
  include ActiveModel::Validations
  include ::Dated

  STATUSES = %w"submitted assigned canceled completed"
  attr_accessible :catering_needs, :description, :equipment_needs, :notes, :people, :submitter_id,
                  :company_name, :contact_person, :contact_email, :contact_phone, :company_address,
                  :start_time, :end_time, :event_date, :submitter_attributes, :website, :building_id

  before_create :create_code
  before_create :set_default_status

  before_update :set_status

  belongs_to :submitter, :class_name => 'User', :foreign_key => :submitter_id
  belongs_to :booking_agent, :class_name => 'User', :foreign_key => :assignee_id
  belongs_to :building
  has_many :events


  accepts_nested_attributes_for :submitter

  validates_presence_of :submitter, :catering_needs, :description, :equipment_needs, :people, :building_id
  validates_presence_of :contact_email, :contact_person, :contact_phone, :company_address
  validates_associated :submitter, :on => :create
  validates :people, :numericality => {:greater_than_or_equal_to => 0}
  validates :website, :allow_blank => true, :url => true


  def event
    @event ||= events.first
  end

  def self.incoming(user)
    if user.role? :admin, Organization
      where("building_id IN (?) AND (status = 'submitted' OR status = 'assigned')", user.buildings).order('assignee_id, status, start_at DESC')
    else
      where("building_id IN (?) AND (status = 'submitted' OR (status = 'assigned' AND assignee_id = ?))", user.buildings, user.id).order('assignee_id, status, start_at DESC')
    end

  end


  private

  def create_code
    self.code = Devise.friendly_token
  end

  def set_default_status
    self.status = STATUSES[0] #submitted
  end

  def set_status
    if self.status == "submitted" and !self.assignee_id.nil? and event.nil?
      self.status = STATUSES[1] #assigned
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



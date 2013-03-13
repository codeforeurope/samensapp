class BookingRequest < ActiveRecord::Base
  attr_accessible :catering_needs, :description, :end_time, :equipment_needs, :notes, :people, :start_time, :submitter_id

  before_create :create_code
  belongs_to :submitter, :class_name => 'User', :foreign_key => :submitter_id
  belongs_to :booking_agent, :class_name => 'User', :foreign_key => :assignee_id
  #has_many :events

  accepts_nested_attributes_for :submitter

  validates_presence_of :submitter, :catering_needs, :description, :end_time, :equipment_needs, :people, :start_time

  private

  def create_code
    self.code = Devise.friendly_token
  end
end

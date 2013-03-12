class BookingRequest < ActiveRecord::Base
  attr_accessible :catering_needs, :description, :end_time, :equipment_needs, :notes, :people, :start_time, :submitter_id
  before_create :save_submitter
  belongs_to :submitter, :class_name => 'User', :foreign_key => :submitter_id
  belongs_to :booking_agent, :class_name => 'User', :foreign_key => :assignee_id
  #has_many :events


  validates_presence_of :submitter, :catering_needs, :description, :end_time, :equipment_needs, :people, :start_time

  private

  def save_submitter
    submitter.save(:validate => false) # this is very hacky, but will do for now
  end
end

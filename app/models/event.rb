class Event < ActiveRecord::Base
  belongs_to :booking_request
  attr_accessible :end_at, :name, :start_at
  has_many :event_rooms
  has_many :rooms, :through => :event_rooms

  validates :end_at, :presence => true
  validates :name, :presence => true
  validates :start_at, :presence => true
  validates :rooms, :presence => true

  accepts_nested_attributes_for :event_rooms, :allow_destroy => true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

end

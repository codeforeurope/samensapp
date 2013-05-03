class Event < ActiveRecord::Base
  belongs_to :booking_request
  attr_accessible :end_at, :name, :start_at
end

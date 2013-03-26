class BookingStatus < ActiveRecord::Base
  STATUSES = %w"locked submitted accepted canceled awaiting_reply"
  attr_accessible :booking_request_id, :description

  belongs_to :booking_request
end

module BookingRequestsHelper

  def format_assignee(assignee_id)
    if assignee_id.nil?
      t(:booking_request_helper.tooltip_none, :default => "None")
    else
      User.find(assignee_id).name
    end
  end

  def format_date(date)
    date.to_formatted_s(:short) unless date.nil?
  end

  def format_date_long(date)
    date.to_formatted_s(:long) unless date.nil?
  end

  def format_status_tooltip(status)
    if status.nil?
      t(:booking_request_helper.tooltip_none, :default => "None")
    else
      case status
        when "submitted"
          t(:booking_request_helper.tooltip_request_submitted, :default => "Request has been received, but not processed yet.")
        when "assigned"
          t(:booking_request_helper.tooltip_request_assigned, :default => "A Booking Agent is working on it, right now.")
        when "completed"
          t(:booking_request_helper.tooltip_request_completed, :default => "An offer has been sent for this request.")
        when "canceled"
          t(:booking_request_helper.tooltip_request_canceled, :default => "The request has been canceled.")
        else
          t(:booking_request_helper.tooltip_request_working, :default => "Working on it.")
      end
    end
  end


end

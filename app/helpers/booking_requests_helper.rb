module BookingRequestsHelper

  def format_assignee(assignee_id)
    if assignee_id.nil?
      t('.tooltip_none')
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
      t('booking_requests.helper.tooltip_none')
    else
      case status
        when "submitted"
          t('booking_requests.helper.tooltip_request_submitted')
        when "assigned"
          t('booking_requests.helper.tooltip_request_assigned')
        when "completed"
          t('booking_requests.helper.tooltip_request_completed')
        when "canceled"
          t('booking_requests.helper.tooltip_request_canceled')
        else
          t('booking_requests.helper.tooltip_request_working')
      end
    end
  end


end

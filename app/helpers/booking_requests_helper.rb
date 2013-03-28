module BookingRequestsHelper

  def format_assignee(assignee_id)
    if assignee_id.nil?
      t('booking_requests.helper.tooltip_none')
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

  def requests_chart_data
    requests_by_day = BookingRequest.grouped_by_day(2.weeks.ago)
    (2.weeks.ago.to_date..Date.today).map do |date|
      {
          created_at: date,
          number: requests_by_day[date].nil? ? 0 : requests_by_day[date]
      }
    end
  end

end

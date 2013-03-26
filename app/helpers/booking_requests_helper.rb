module BookingRequestsHelper

  def format_assignee(assignee_id)
    if assignee_id.nil?
      t("None")
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
      t("None")
    else
      case status
        when "submitted"
          "Request has been received, but not processed yet."
        when "locked"
          "A Booking Agent is working on it, right now."
        else
          "Working on it"
      end
    end
  end


end

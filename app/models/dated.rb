module Dated
  def start_time
    @start_time || time_attr_from_datetime(start_at)
  end

  def start_time=(start_time_value)
    @start_time = start_time_value
    set_start_at
  end

  def end_time
    @end_time || time_attr_from_datetime(end_at)
  end

  def end_time=(end_time_value)
    @end_time =end_time_value
    set_end_at
  end

  def event_date
    @event_date || (start_at.to_date.to_s(:db) if start_at)
  end

  def event_date=(event_date_value)
    @event_date = event_date_value
    set_start_at
    set_end_at
  end

  def start_at=(start_at_value)
    write_attribute(:start_at, start_at_value) # Maybe you need to do write_attribute(:start_at, DateTime.parse(start_at_value)) here ???
    @start_time = time_attr_from_datetime(start_at)
  end

  def end_at=(end_at_value)
    write_attribute(:end_at, end_at_value) # Maybe you need to do write_attribute(:end_at, DateTime.parse(end_at_value)) here ???
    @end_time = time_attr_from_datetime(end_at)
  end

  private
  def set_start_at
    start_at = Time.zone.parse("#{event_date} #{start_time}:00") unless start_time.blank?
  end

  def set_end_at
    end_at = Time.zone.parse("#{event_date} #{end_time}:00") unless end_time.blank?
  end

  def time_attr_from_datetime(datetime)
    "#{'%02d' % datetime.hour}:#{'%02d' % datetime.min}" unless datetime.blank?
  end
end

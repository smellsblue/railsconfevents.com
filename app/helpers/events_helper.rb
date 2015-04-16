module EventsHelper
  def event_day_label(day)
    Date.strptime(day, "%m/%d/%Y").strftime "%A, %B %-d"
  end
end

module EventsHelper
  def additional_event_well_classes(event)
    return if event.listed?

    if active_user.admin?
      "unlisted"
    else
      "pending"
    end
  end

  def event_day_label(day)
    Date.strptime(day, "%m/%d/%Y").strftime "%A, %B %-d"
  end
end

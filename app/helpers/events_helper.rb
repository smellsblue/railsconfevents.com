module EventsHelper
  def additional_event_well_classes(event)
    return if event.listed?

    if active_user.admin?
      "unlisted"
    else
      "pending"
    end
  end
end

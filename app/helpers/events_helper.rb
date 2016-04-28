module EventsHelper
  def coordinator_col_class
    if active_user.can_specify_user_coordinators?
      "col-sm-4"
    else
      "col-sm-6"
    end
  end
end

module ApplicationHelper
  def active_user
    current_user || Anonymous.user
  end

  def flash_class_for(type)
    case type
    when :alert
      :error
    when :notice
      :info
    else
      type
    end
  end
end

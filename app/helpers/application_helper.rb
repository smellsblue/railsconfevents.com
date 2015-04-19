module ApplicationHelper
  def active_user
    current_user || Anonymous.user
  end

  def current_conference
    @current_conference ||= Conference.current
  end

  def flash_class_for(type)
    case type
    when :alert
      :danger
    when :error
      :danger
    when :notice
      :info
    else
      type
    end
  end

  def me_active?
    params[:controller] == "users" && params[:action] == "me"
  end

  def partial(name, locals = {}, &block)
    if block
      raise "Cannot have a 'body' local when a block is given!" if locals.include?(:body)
      locals[:body] = capture &block
    end

    render partial: name, locals: locals
  end

  def user_avatar(user, options = { height: "16" })
    if user.avatar.present?
      image_tag user.avatar, options
    end
  end

  def user_github_link(user, options = {})
    if options[:label]
      label = options[:label] || "[unknown]"
    else
      label = user.display_name
    end

    if user.github_path.present?
      link_to label, user.github_path
    else
      label
    end
  end

  def users_active?
    params[:controller] == "users" && params[:action] != "me"
  end
end

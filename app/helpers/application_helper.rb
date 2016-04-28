module ApplicationHelper
  def active_user
    current_user || Anonymous.user
  end

  def current_conference
    @current_conference ||= Conference.current
  end

  def format_date(date)
    if date
      date.strftime "%-m/%-d/%Y"
    end
  end

  def format_time(time)
    if time
      time.strftime "%-I:%M %p"
    end
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

  def user_singup_and_login_path
    if Rails.env.production?
      user_omniauth_authorize_path :github
    else
      user_omniauth_authorize_path :developer
    end
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

    link_to_if user.github_path.present?, label, user.github_path
  end

  def conferences_active?
    params[:controller] == "conferences"
  end

  def users_active?
    params[:controller] == "users" && params[:action] != "me"
  end
end

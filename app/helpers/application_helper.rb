module ApplicationHelper
  def active_user
    current_user || Anonymous.user
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

  def partial(name, locals = {}, &block)
    if block
      raise "Cannot have a 'body' local when a block is given!" if locals.include?(:body)
      locals[:body] = capture &block
    end

    render partial: name, locals: locals
  end
end

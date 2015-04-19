module EventCreator
  extend ActiveSupport::Concern

  def can_delete?(event)
    admin?
  end

  def can_edit?(event)
    admin? || event.creator == self
  end

  def can_list?(event)
    admin?
  end

  def create_event!(params, ip)
    Event.create! do |event|
      event.creator = self
      event.fill params
      event.listed = true
    end
  end

  def destroy_event!(params)
    event = Event.find params[:id]
    raise PermissionError.new unless can_delete? event
    return if event.deleted?
    event.deleted = true
    event.deleted_by = self
    event.deleted_at = Time.now
    event.save!
  end

  def edit_event!(params)
    event = Event.find params[:id]
    raise PermissionError.new unless can_edit? event
    event.fill params
    event.save!
  end

  def list_event!(params)
    event = Event.find params[:id]
    return if event.listed?
    event.listed = true
    event.save!
  end

  module Anonymous
    extend ActiveSupport::Concern

    def can_delete?(event)
      false
    end

    def can_edit?(event)
      false
    end

    def can_list?(event)
      false
    end

    def create_event!(params, ip)
      Event.create! do |event|
        event.anonymous_user_ip = ip
        event.listed = false
        event.fill params
      end
    end

    def destroy_event!(params)
      raise PermissionError.new
    end

    def edit_event!(params)
      raise PermissionError.new
    end

    def list_event!(params)
      raise PermissionError.new
    end
  end
end

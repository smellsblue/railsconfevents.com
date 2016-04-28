module EventCreator
  extend ActiveSupport::Concern

  def can_delete?(event)
    admin?
  end

  def can_edit?(event)
    admin? || event.creator == self || event.coordinator?(self)
  end

  def can_list?(event)
    admin?
  end

  def can_specify_user_coordinators?
    true
  end

  def comment_on_event!(params)
    event = Event.find params[:event_id]

    event.comments.create! do |comment|
      comment.creator = self
      comment.text = params[:comment]
    end
  end

  def create_event!(params, ip)
    transaction do
      Conference.current.events.create! do |event|
        event.creator = self
        event.fill params
        event.listed = true
      end
    end
  end

  def destroy_event!(params)
    event = Event.find params[:id]
    raise PermissionError unless can_delete? event
    return if event.deleted?
    event.deleted = true
    event.deleted_by = self
    event.deleted_at = Time.now
    event.save!
  end

  def edit_event!(params)
    transaction do
      event = Event.find params[:id]
      raise PermissionError unless can_edit? event
      event.fill params
      event.save!
    end
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

    def can_specify_user_coordinators?
      false
    end

    def comment_on_event!(params)
      raise PermissionError
    end

    def create_event!(params, ip)
      Event.transaction do
        Conference.current.events.create! do |event|
          event.anonymous_user_ip = ip
          event.listed = false
          event.fill params
          raise PermissionError if event.coordinators.any?(&:user?)
        end
      end
    end

    def destroy_event!(params)
      raise PermissionError
    end

    def edit_event!(params)
      raise PermissionError
    end

    def list_event!(params)
      raise PermissionError
    end
  end
end

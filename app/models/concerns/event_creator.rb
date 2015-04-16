module EventCreator
  extend ActiveSupport::Concern

  def create_event!(params, ip)
    Event.create! do |event|
      event.creator = self
      event.listed = true
      event.fill params
    end
  end

  module Anonymous
    extend ActiveSupport::Concern

    def create_event!(params, ip)
      Event.create! do |event|
        event.anonymous_user_ip = ip
        event.listed = false
        event.fill params
      end
    end
  end
end

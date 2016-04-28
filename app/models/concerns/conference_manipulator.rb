module ConferenceManipulator
  extend ActiveSupport::Concern

  def can_manipulate_conferences?
    super_admin?
  end

  def edit_conference!(params)
    raise PermissionError unless can_manipulate_conferences?
    conference = Conference.find params[:id]
    conference.fill params
    conference.save!
  end

  module Anonymous
    extend ActiveSupport::Concern

    def can_manipulate_conferences?
      false
    end

    def edit_conference!(params)
      raise PermissionError
    end
  end
end

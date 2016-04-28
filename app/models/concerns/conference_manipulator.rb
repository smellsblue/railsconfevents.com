module ConferenceManipulator
  extend ActiveSupport::Concern

  def can_manipulate_conferences?
    super_admin?
  end

  module Anonymous
    extend ActiveSupport::Concern

    def can_manipulate_conferences?
      false
    end
  end
end

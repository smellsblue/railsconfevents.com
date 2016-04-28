module IsUser
  extend ActiveSupport::Concern
  include ConferenceManipulator
  include EventCreator
  include UserInfo
  include UserManipulator

  module Anonymous
    extend ActiveSupport::Concern
    include ConferenceManipulator::Anonymous
    include EventCreator::Anonymous
    include UserInfo::Anonymous
    include UserManipulator::Anonymous
  end
end

module IsUser
  extend ActiveSupport::Concern
  include EventCreator
  include UserInfo
  include UserManipulator

  module Anonymous
    extend ActiveSupport::Concern
    include EventCreator::Anonymous
    include UserInfo::Anonymous
    include UserManipulator::Anonymous
  end
end

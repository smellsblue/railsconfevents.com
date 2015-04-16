module IsUser
  extend ActiveSupport::Concern
  include UserInfo
  include EventCreator

  module Anonymous
    extend ActiveSupport::Concern
    include UserInfo::Anonymous
    include EventCreator::Anonymous
  end
end

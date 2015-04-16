module UserInfo
  extend ActiveSupport::Concern

  def anonymous?
    false
  end

  def display_name
    name || username || email || "Someone"
  end

  module Anonymous
    extend ActiveSupport::Concern

    def id
      nil
    end

    def anonymous?
      true
    end

    def display_name
      "anonymous"
    end
  end
end

module UserInfo
  extend ActiveSupport::Concern

  def anonymous?
    false
  end

  def display_name
    name || username || email || "Someone"
  end

  def github_path
    if username
      "https://github.com/#{username}"
    end
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

    def github_path
      nil
    end
  end
end

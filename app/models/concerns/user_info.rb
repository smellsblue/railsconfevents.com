module UserInfo
  extend ActiveSupport::Concern

  def display_name
    name || username || email || "Someone"
  end

  def github_path
    if username
      "https://github.com/#{username}"
    end
  end

  # Common methods
  def admin?
    super_admin? || role == "admin"
  end

  def anonymous?
    role == "anonymous"
  end

  def super_admin?
    role == "super_admin"
  end

  module Anonymous
    extend ActiveSupport::Concern
    include UserInfo

    def id
      nil
    end

    def display_name
      "anonymous"
    end

    def github_path
      nil
    end

    def role
      "anonymous"
    end
  end
end

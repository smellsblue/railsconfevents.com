module UserInfo
  extend ActiveSupport::Concern

  def display_name
    name.presence || username.presence || "Someone"
  end

  def github_path
    if username
      "https://github.com/#{username}"
    end
  end

  def update_me!(params)
    raise "Name is required!" unless params[:name].present?
    self.name = params[:name]
    self.email = params[:email]

    if really_admin?
      if params[:incognito] == "true" && !(role =~ /\Aincognito_/)
        self.role = "incognito_#{role}"
      elsif params[:incognito].blank? && role =~ /\Aincognito_/
        self.role[/\Aincognito_/] = ""
      end
    end

    save!
  end

  # Common methods
  def admin?
    super_admin? || role == "admin"
  end

  def anonymous?
    role == "anonymous"
  end

  def incognito_admin?
    role == "incognito_admin" || role == "incognito_super_admin"
  end

  def really_admin?
    incognito_admin? || admin?
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

    def update_me!(params)
      raise PermissionError.new
    end
  end
end

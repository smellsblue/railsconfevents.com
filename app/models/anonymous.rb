class Anonymous
  def id
    nil
  end

  def anonymous?
    true
  end

  def display_name
    "anonymous"
  end

  class << self
    def user
      new
    end
  end
end

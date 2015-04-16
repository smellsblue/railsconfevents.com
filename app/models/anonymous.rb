class Anonymous
  def id
    nil
  end

  def anonymous?
    true
  end

  class << self
    def user
      new
    end
  end
end

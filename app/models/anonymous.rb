class Anonymous
  include IsUser::Anonymous

  class << self
    def user
      new
    end
  end
end

class User < ActiveRecord::Base
  devise :omniauthable, :rememberable, :trackable

  def anonymous?
    false
  end

  class << self
    def from_auth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.username = auth.info.nickname
        user.email = auth.info.email
        user.avatar = auth.info.image
      end
    end
  end
end

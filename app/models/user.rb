class User < ActiveRecord::Base
  devise :omniauthable, :rememberable, :trackable
  include IsUser

  before_save :adjust_twitter_handle

  def adjust_twitter_handle
    self.twitter_handle = "@#{self.twitter_handle}" if self.twitter_handle.present? && self.twitter_handle[0] != '@'
  end

  class << self
    def for_admin
      order(:name, :username, :email)
    end

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

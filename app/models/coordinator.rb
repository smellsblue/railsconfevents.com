class Coordinator < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates :twitter, twitter: true
  validates :username, github: true
  after_find :update_user_from_username

  def matches?(name, twitter, github)
    self.name.to_s == name.to_s && self.twitter.to_s == twitter.to_s && self.github_username.to_s == github
  end

  def user?
    user.present? || username.present?
  end

  def github_username
    if user
      user.username
    elsif username.present?
      username
    end
  end

  private

  def update_user_from_username
    return if username.blank?

    transaction do
      user = User.find_by_username(username)
      return unless user
      self.user = user
      self.username = nil
      save!
    end
  end
end

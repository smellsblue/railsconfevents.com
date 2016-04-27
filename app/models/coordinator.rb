class Coordinator < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates_format_of :twitter, :with => /\A[a-zA-Z0-9_]{0,15}\z/
  after_find :update_user_from_username

  def user?
    user.present?
  end

  def github_username
    if user?
      user.username
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

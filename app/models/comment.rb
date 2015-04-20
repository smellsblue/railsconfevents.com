class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  belongs_to :event, counter_cache: true

  class << self
    def for_display
      reverse_chronological.includes(:creator)
    end

    def reverse_chronological
      order "created_at DESC"
    end
  end
end

class Comment < ActiveRecord::Base
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  belongs_to :event, counter_cache: true
end

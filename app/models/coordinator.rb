class Coordinator < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates_format_of :twitter, :with => /\A[a-zA-Z0-9_]{0,15}\z/
end

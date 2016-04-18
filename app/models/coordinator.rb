class Coordinator < ActiveRecord::Base
  belongs_to :event
  validates_format_of :twitter, :with => /\A[a-zA-Z0-9_]{0,15}\z/
end

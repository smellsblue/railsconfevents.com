class Conference < ActiveRecord::Base
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  has_many :events

  def example_event_date
    (starting_at + 1.day).strftime "%-m/%-d/%Y"
  end

  def iso_valid_end_date
    allow_ending_at.strftime "%Y-%m-%d"
  end

  def iso_valid_start_date
    allow_starting_at.strftime "%Y-%m-%d"
  end

  def valid_end_date
    allow_ending_at.strftime "%-m/%-d"
  end

  def valid_start_date
    allow_starting_at.strftime "%-m/%-d"
  end

  class << self
    def current
      where(year: Time.now.year).first
    end
  end
end

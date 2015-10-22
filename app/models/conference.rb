class Conference < ActiveRecord::Base
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  has_many :events

  def each_day(active_user)
    events = Event.for_user(active_user).to_a

    allow_starting_at.upto allow_ending_at do |date|
      day = Day.new self, events, date

      if day.empty?
        next unless day.conference_day?
      end

      yield day
    end
  end

  def example_event_date
    (starting_at + 1.day).strftime "%-m/%-d/%Y"
  end

  def iso_valid_end_date
    allow_ending_at.strftime "%Y-%m-%d"
  end

  def iso_valid_start_date
    allow_starting_at.strftime "%Y-%m-%d"
  end

  def parse_date_time(time_str)
    zone.parse DateTime.strptime(time_str, "%m/%d/%Y %I:%M %p").strftime("%Y-%m-%d %H:%M:%S")
  end

  def valid_end_date
    allow_ending_at.strftime "%-m/%-d"
  end

  def valid_start_date
    allow_starting_at.strftime "%-m/%-d"
  end

  def zone
    ActiveSupport::TimeZone[timezone]
  end

  class << self
    def current
      where('allow_ending_at > ?', Date.today).order('allow_ending_at ASC').first
    end
  end
end

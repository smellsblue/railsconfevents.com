class Conference < ActiveRecord::Base
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  has_many :events
  validate :dates_match_year
  validate :dates_in_proper_order

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

  def fill(params)
    self.year = params[:year]
    self.timezone = params[:timezone]
    self.starting_at = Date.strptime(params[:start_date], "%m/%d/%Y")
    self.ending_at = Date.strptime(params[:end_date], "%m/%d/%Y")
    self.allow_starting_at = Date.strptime(params[:allow_start_date], "%m/%d/%Y")
    self.allow_ending_at = Date.strptime(params[:allow_end_date], "%m/%d/%Y")
    self.header = params[:header]
  end

  private

  def dates_match_year
    [:allow_starting_at, :starting_at, :ending_at, :allow_ending_at].each do |field|
      if send(field).year != year
        errors.add(field, "must be in the year of the conference")
      end
    end
  end

  FIELD_LABELS = {
    allow_starting_at: "allowed start date",
    starting_at: "conference start date",
    ending_at: "conference end date",
    allow_ending_at: "allowed end date",
  }

  def dates_in_proper_order
    {
      allow_starting_at: [:starting_at, :ending_at, :allow_ending_at],
      starting_at: [:ending_at, :allow_ending_at],
      ending_at: [:allow_ending_at]
    }.each do |check_field, fields|
      fields.each do |field|
        if send(field) < send(check_field)
          errors.add(field, "must be greater or equal to the #{FIELD_LABELS[check_field]}")
        end
      end
    end

    {
      allow_ending_at: [:allow_starting_at, :starting_at, :ending_at],
      ending_at: [:allow_starting_at, :starting_at],
      starting_at: [:allow_starting_at]
    }.each do |check_field, fields|
      fields.each do |field|
        if send(field) > send(check_field)
          errors.add(field, "must be less than or equal to the #{FIELD_LABELS[check_field]}")
        end
      end
    end
  end

  class << self
    def for_admin
      order(:year, :starting_at)
    end

    def current
      where(year: Time.now.year).first
    end
  end
end

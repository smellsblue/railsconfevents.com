class Day
  attr_reader :conference, :events, :date

  def initialize(conference, events, date)
    @conference = conference
    @events = events.select { |x| x.starting_at.to_date == date }
    @date = date
  end

  def conference_day?
    date >= conference.starting_at && date <= conference.ending_at
  end

  def display_classes
    if date < Date.today
      "past"
    elsif date == Date.today
      "current"
    elsif date > Date.today
      "future"
    end
  end

  def empty?
    events.empty?
  end

  def label
    date.strftime "%A, %B %-d"
  end
end

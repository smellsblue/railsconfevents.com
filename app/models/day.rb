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

  def current?
    time_state == :current
  end

  def display_classes
    case time_state
    when :past
      "past"
    when :current
      "current"
    when :future
      "future"
    end
  end

  def display_id
    date.strftime "day-%Y-%m-%d"
  end

  def empty?
    events.empty?
  end

  def entirely_past?
    if empty?
      past?
    else
      events.all? { |x| x.past? }
    end
  end

  def future?
    time_state == :future
  end

  def label
    date.strftime "%A, %B %-d"
  end

  def past?
    time_state == :past
  end

  def time_state
    if date < Date.today
      :past
    elsif date == Date.today
      :current
    elsif date > Date.today
      :future
    end
  end
end

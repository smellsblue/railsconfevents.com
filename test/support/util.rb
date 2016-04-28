def current_year
  Time.zone.now.year
end

def format_date(date)
  if date
    date.strftime "%-m/%-d/%Y"
  end
end

def format_time(time)
  if time
    time.strftime "%-I:%M %p"
  end
end

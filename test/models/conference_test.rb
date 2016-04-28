require "test_helper"

class ConferenceTest < ActiveSupport::TestCase
  def test_current_conference
    Timecop.freeze Time.local(current_year, 4, 19, 14, 10, 0) do
      assert_equal conferences(:railsconf_current), Conference.current
    end
  end

  def test_each_day_doesnt_include_empty_days_outside_conference
    conference = conferences :railsconf_current
    test_day = Date.strptime "#{current_year}-04-18"
    assert_equal 0, conference.events.where(starting_at: (test_day.beginning_of_day..test_day.end_of_day)).count, "No events should be scheduled for #{test_day}"

    conference.each_day users(:fry) do |day|
      assert_not_equal test_day, day.date
    end
  end

  def test_each_day_includes_empty_conference_days
    conference = conferences :railsconf_current
    test_day = Date.strptime "#{current_year}-04-23"
    assert_equal 0, conference.events.where(starting_at: (test_day.beginning_of_day..test_day.end_of_day)).count, "No events should be scheduled for #{test_day}"
    contained = false

    conference.each_day users(:fry) do |day|
      if test_day == day.date
        contained = true
      end
    end

    assert contained, "The test day should be contained in the iterated days"
  end
end

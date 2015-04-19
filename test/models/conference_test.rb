require "test_helper"

class ConferenceTest < ActiveSupport::TestCase
  def test_current_conference
    Timecop.freeze Time.local(2015, 4, 19, 14, 10, 0) do
      assert_equal conferences(:railsconf2015), Conference.current
    end
  end
end

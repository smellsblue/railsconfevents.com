class AddTimezoneToConference < ActiveRecord::Migration
  def change
    change_table :conferences do |t|
      t.string :timezone
    end

    Conference.all.each do |conference|
      conference.timezone = "Eastern Time (US & Canada)"
      conference.save!

      conference.events.each do |event|
        event.starting_at = fixed_time conference, event.read_attribute(:starting_at)
        event.ending_at = fixed_time conference, event.read_attribute(:ending_at)
        event.save!
      end
    end

    change_column_null :conferences, :timezone, false
  end

  def fixed_time(conference, time)
    conference.parse_date_time time.strftime("%m/%d/%Y %I:%M %p")
  end
end

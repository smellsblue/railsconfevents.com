class Event < ActiveRecord::Base
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  belongs_to :deleted_by, foreign_key: "deleted_by_user_id", class_name: "User"
  validates :name, presence: true
  validates_format_of :coordinator_twitter, :with => /\A[a-zA-Z0-9_]{1,15}\z/

  def display_end_time
    ending_at.strftime "%-I:%M %p"
  end

  def display_start_time
    starting_at.strftime "%-I:%M %p"
  end

  def fill(params)
    self.name = params[:name]
    self.coordinator = params[:coordinator]
    self.coordinator_twitter = params[:coordinator_twitter]
    self.url = params[:url]
    self.location = params[:location]
    self.description = params[:description]
    self.starting_at = DateTime.strptime "#{params[:date]} #{params[:start_time]}", "%m/%d/%Y %I:%M %p"
    self.ending_at = DateTime.strptime "#{params[:date]} #{params[:end_time]}", "%m/%d/%Y %I:%M %p"

    if ending_at < starting_at
      self.ending_at += 1.day
    end
  end

  class << self
    def display_order
      order :starting_at, :ending_at, :name
    end

    def for_day(active_user, day)
      if active_user.admin?
        includes(:creator).not_deleted.on_day(Date.strptime(day, "%m/%d/%Y")).display_order
      else
        includes(:creator).listed.not_deleted.on_day(Date.strptime(day, "%m/%d/%Y")).display_order
      end
    end

    def listed
      where listed: true
    end

    def not_deleted
      where deleted: false
    end

    def on_day(day)
      where starting_at: (day.beginning_of_day..day.end_of_day)
    end
  end
end

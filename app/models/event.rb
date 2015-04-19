class Event < ActiveRecord::Base
  belongs_to :conference
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  belongs_to :deleted_by, foreign_key: "deleted_by_user_id", class_name: "User"
  validates :name, presence: true
  validates_format_of :coordinator_twitter, :with => /\A[a-zA-Z0-9_]{0,15}\z/
  validate :date_within_conference_allowed_dates

  def display_end_time
    ending_at.strftime "%-I:%M %p"
  end

  def display_start_time
    starting_at.strftime "%-I:%M %p"
  end

  def edit_date
    if starting_at
      starting_at.strftime "%-m/%-d/%Y"
    end
  end

  def edit_end_time
    if ending_at
      ending_at.strftime "%-I:%M %p"
    end
  end

  def edit_start_time
    if starting_at
      starting_at.strftime "%-I:%M %p"
    end
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

  private

  def date_within_conference_allowed_dates
    if starting_at.to_date < conference.allow_starting_at
      errors.add(:starting_at, "can't be before conference allowed start")
    end

    if starting_at.to_date > conference.allow_ending_at
      errors.add(:starting_at, "can't be after conference allowed end")
    end
  end

  class << self
    def display_order
      order :starting_at, :ending_at, :name
    end

    def for_user(active_user)
      if active_user.admin?
        includes(:creator).not_deleted.display_order
      else
        includes(:creator).listed_or_by(active_user).not_deleted.display_order
      end
    end

    def listed
      where listed: true
    end

    def listed_or_by(user)
      if user.anonymous?
        listed
      else
        where "(listed = ? OR creator_user_id = ?)", true, user.id
      end
    end

    def not_deleted
      where deleted: false
    end
  end
end

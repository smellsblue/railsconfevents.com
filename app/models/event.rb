class Event < ActiveRecord::Base
  belongs_to :conference
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  belongs_to :deleted_by, foreign_key: "deleted_by_user_id", class_name: "User"
  has_many :coordinators
  has_many :comments
  validates :name, presence: true
  validate :date_within_conference_allowed_dates

  def coordinator?(user)
    return false unless user
    coordinators.map(&:user).include?(user)
  end

  def current?
    time_state == :current
  end

  def display_classes(active_user)
    classes = []

    unless listed?
      if active_user.admin?
        classes << "unlisted"
      else
        classes << "pending"
      end
    end

    case time_state
    when :past
      classes << "past"
    when :current
      classes << "current"
    when :future
      classes << "future"
    end

    classes.join " "
  end

  def display_id
    "event-#{id}"
  end

  def displayable_comments
    comments.for_display
  end

  def ending_at
    fix_tz read_attribute(:ending_at)
  end

  def fill(params)
    self.name = params[:name]
    fill_coordinators(params)
    self.url = params[:url]
    self.location = params[:location]
    self.description = params[:description]
    self.starting_at = conference.parse_date_time "#{params[:date]} #{params[:start_time]}"
    self.ending_at = conference.parse_date_time  "#{params[:date]} #{params[:end_time]}"

    if ending_at < starting_at
      self.ending_at += 1.day
    end
  end

  def fill_coordinators(params)
    raise "Invalid coordinators!" unless params[:coordinators].to_a.size == params[:coordinator_twitters].to_a.size
    raise "Invalid coordinators!" if params[:coordinator_githubs].present? && params[:coordinators].to_a.size != params[:coordinator_githubs].to_a.size
    coordinators.destroy_all
    return if params[:coordinators].blank? && params[:coordinator_twitters].blank? && params[:coordinator_githubs].blank?

    params[:coordinators].to_a.each_with_index do |name, i|
      twitter = params[:coordinator_twitters][i]
      github = params[:coordinator_githubs][i] if params[:coordinator_githubs].present?
      next if name.blank? && twitter.blank? && github.blank?
      user = User.find_by_username(github) if github.present?

      if user
        next if coordinators.any? { |x| x.user == user }
        coordinators.build name: name, twitter: twitter, user: user
      else
        next if coordinators.any? { |x| x.matches?(name, twitter, github) }
        coordinators.build name: name, twitter: twitter, username: github
      end
    end
  end

  def future?
    time_state == :future
  end

  def past?
    time_state == :past
  end

  def starting_at
    fix_tz read_attribute(:starting_at)
  end

  def time_state
    now = conference.zone.now

    if ending_at < now
      :past
    elsif starting_at <= now && ending_at >= now
      :current
    elsif starting_at > now
      :future
    end
  end

  def signups_enabled?
    # TODO
    false
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

  def fix_tz(time)
    if time
      time.in_time_zone conference.timezone
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

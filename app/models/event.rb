class Event < ActiveRecord::Base
  belongs_to :creator, foreign_key: "creator_user_id", class_name: "User"
  belongs_to :deleted_by, foreign_key: "deleted_by_user_id", class_name: "User"

  def fill(params)
    self.name = params[:name]
    self.coordinator = params[:coordinator]
    self.coordinator_twitter = params[:coordinator_twitter]
    self.url = params[:url]
    self.location = params[:location]
    self.description = params[:description]

    # TODO
    self.starting_at = params[:starting_at]
    self.ending_at = params[:ending_at]
  end
end

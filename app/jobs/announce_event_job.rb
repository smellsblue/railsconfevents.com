class AnnounceEventJob < ActiveJob::Base
  queue_as :default

  include Rails.application.routes.url_helpers

  def perform(event)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["RAILSCONFEVENTS_TWITTER_KEY"]
      config.consumer_secret = ENV["RAILSCONFEVENTS_TWITTER_SECRET"]
      config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    tweet_users = User.where("notify_twitter = ? AND twitter_handle <> ?", true, "")

    tweet_users.each do |user|
      url = event_url(event.id)
      tweet = "#{user.twitter_handle}, there's a new event on RailsConfEvents! #{url}"
      client.update(tweet)
    end
  end

  def default_url_options
    ActionMailer::Base.default_url_options
  end
end

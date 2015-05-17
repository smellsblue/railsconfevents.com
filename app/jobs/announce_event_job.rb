class AnnounceEventJob < ActiveJob::Base
  queue_as :default

  include Rails.application.routes.url_helpers

  def perform(event)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.secrets.twitter_consumer_key
      config.consumer_secret = Rails.application.secrets.twitter_consumer_secret
      config.access_token = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_secret
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

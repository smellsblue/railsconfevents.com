# RailsConfEvents.com

This is a simple Rails application intended to be a community driven
repository of the official and unofficial events happening during (and
surrounding) RailsConf 2015. If it goes well, then it could be a site that
sticks around for every RailsConf to list past and present RailsConf events.

## Getting Started
You'll need to have both Github and Twitter applications set up in order to get have the full functionality of the
application available.  Create a config/application.yml file to store your environment variables.


### Github
* Go to https://github.com/settings/applications/new, fill out the form.  The callback URL should be something along the
lines of http://localhost:3000/users/auth/github/callback, depending on how exactly you're running the server and what port it is on.
* After submitting the form, record the provided 'Client ID' and 'Client Secret'.  Put those values in the application.yml file
with the keys RAILSCONFEVENTS_GITHUB_KEY and RAILSCONFEVENTS_GITHUB_SECRET, respectively.

### Twitter
* This application will send all tweets from a single Twitter account.  If necessary, create a new account, and follow the next
steps while logged into that account.
* Go to http://apps.twitter.com, and create a new app.  Nothing needs to be filled in on the Callback URL field.
* In the 'Keys and Access Tokens' tab, copy the 'Consumer Key (API Key)' and 'Consumer Secret (API Secret)' values into
application.yml with the keys RAILSCONFEVENTS_TWITTER_KEY and RAILSCONFEVENTS_TWITTER_SECRET, respectively.
* Towards the bottom of the same page, click the button to activate "Your Access Token".  Copy the 'Access Token' and
'Access Token Secret' to your application.yml as TWITTER_ACCESS_TOKEN and TWITTER_ACCESS_SECRET, respectively.

## Ideas?

Go ahead and open an issue on GitHub! If you want to dive in to the code, go
ahead and submit a pull request. If you like, you can message me about it.

## Got an event?

Visit https://railsconfevents.com/ and submit your event! If you create an
account first, you will be able to see the event before it gets approved.
Creating an account is as simple as clicking the Sign In / Register link, and
then logging in via GitHub. You can also edit events if you created an
account first.

Please note that I reserve the right to filter obscene or otherwise offensive
events, and approving an event is by no means an endorsement of that event by
me or anyone else. Was all that really necessary to say? I think our
community is pretty awesome, so I trust only awesome and inclusive events
will be listed!

## License

This project is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).

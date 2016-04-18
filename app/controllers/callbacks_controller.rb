class CallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token, only: :developer
  include Devise::Controllers::Rememberable

  def developer
    raise "Not allowed in production" if Rails.env.production?
    user = User.from_auth request.env["omniauth.auth"]
    sign_in_and_redirect user
    remember_me user
  end

  def github
    user = User.from_auth request.env["omniauth.auth"]
    sign_in_and_redirect user
    remember_me user
  end
end

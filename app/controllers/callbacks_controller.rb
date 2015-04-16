class CallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def github
    user = User.from_auth request.env["omniauth.auth"]
    sign_in_and_redirect user
    remember_me user
  end
end

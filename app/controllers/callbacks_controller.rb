class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_auth request.env["omniauth.auth"]
    sign_in_and_redirect @user
  end
end

class UsersController < ApplicationController
  before_filter :verify_access, except: [:me, :update_me]

  def index
  end

  def me
  end

  def promote
    active_user.promote_user! params
    flash[:error] = "You promoted a user!"
    redirect_to users_path
  end

  def update_me
    active_user.update_me! params
    flash[:info] = "Your user information has been updated."
    redirect_to me_users_path
  end

  private

  def verify_access
    raise PermissionError unless active_user.can_manipulate_users?
  end
end

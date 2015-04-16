class UsersController < ApplicationController
  before_filter :verify_access

  def index
  end

  def promote
    active_user.promote_user! params
    flash[:error] = "You promoted a user!"
    redirect_to action: :index
  end

  private

  def verify_access
    raise "You do not have permission to be here!" unless active_user.super_admin?
  end
end

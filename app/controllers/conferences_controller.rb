class ConferencesController < ApplicationController
  before_filter :verify_access

  def index
  end

  def edit
    @conference = Conference.find params[:id]
  end

  def update
    active_user.edit_conference! params
    flash[:info] = "The conference has been updated."
    redirect_to conferences_path
  end

  private

  def verify_access
    raise PermissionError unless active_user.can_manipulate_conferences?
  end
end

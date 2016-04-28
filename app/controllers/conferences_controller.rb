class ConferencesController < ApplicationController
  before_filter :verify_access

  def index
  end

  def edit
    @conference = Conference.find params[:id]
  end

  private

  def verify_access
    raise PermissionError unless active_user.can_manipulate_conferences?
  end
end

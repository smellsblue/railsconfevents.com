class EventsController < ApplicationController
  def create
    active_user.create_event! params, request.remote_ip
    flash[:info] = "Thanks for submitting your event!"
    redirect_to action: :index
  end

  def index
  end

  def new
  end
end

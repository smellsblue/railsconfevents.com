class EventsController < ApplicationController
  def create
    active_user.create_event! params, request.remote_ip
    flash[:info] = "Thanks for submitting your event!"
    redirect_to action: :index
  end

  def destroy
    active_user.destroy_event! params
    flash[:error] = "Event deleted!"
    redirect_to action: :index
  end

  def index
  end

  def list
    active_user.list_event! params
    flash[:error] = "Event listed!"
    redirect_to action: :index
  end

  def new
  end
end

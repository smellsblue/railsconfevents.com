class EventsController < ApplicationController
  def create
    active_user.create_event! params, request.remote_ip
    flash[:info] = "Thanks for submitting your event!"
    redirect_to events_path
  end

  def destroy
    active_user.destroy_event! params
    flash[:error] = "Event deleted!"
    redirect_to events_path
  end

  def edit
    @event = Event.find params[:id]
    raise PermissionError unless active_user.can_edit? @event
  end

  def index
  end

  def list
    active_user.list_event! params
    flash[:error] = "Event listed!"
    redirect_to events_path
  end

  def new
  end

  def show
    @event = Event.find params[:id]
  end

  def update
    active_user.edit_event! params
    flash[:info] = "Thanks for editing your event!"
    redirect_to events_path
  end
end

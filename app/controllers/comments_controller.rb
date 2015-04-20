class CommentsController < ApplicationController
  def create
    event = Event.find params[:event_id]
    active_user.comment_on_event! params
    flash[:info] = "Thank you for your comment!"
    redirect_to event
  end
end

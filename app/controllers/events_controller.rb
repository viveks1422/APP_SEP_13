class EventsController < ApplicationController
  require 'unidecoder'
  before_filter :authenticate_user!

  def index
    @events = Event.all
    @myEvents = Event.where(:user_id => current_user).all
    @allEvents = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { @events }
    end
  end

  def show
    @event = Event.find(params[:id])
    session[:event_id] = @event.id

    respond_to do |format|
      format.html # show.html.erb
      format.json { @event }
    end
  end

  def new
    @event = current_user.events.new
    event_timings = @event.event_timings.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @event = Event.find(params[:id])
    
    respond_to do |format|
      format.html # edit.html.erb
    end
  end

  def create
    @event = current_user.events.new(params[:event])

      if created_event = Event.create!(params[:event])
        session[:event_id] = created_event.id
        redirect_to event_steps_path, notice: "Personal Information was successfully created"
      else
        render action: "new"
      end
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(params[:event])
      session[:event_id] = @event.id
      redirect_to event_steps_path
    end
  end

  def verify
    @event = Event.find(params[:id])
    @event.save

    respond_to do |format|
      session[:event_id] = @event.id
      format.html # verify.html.erb
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def import
    @event = current_user.events.import(params[:file])
    redirect_to root_url, notice: "Events imported."
  end

protected

  def authorize!
    unless user_signed_in? && current_user.admin?
      flash[:error] = "Unauthorized Access"
      redirect_to new_event_path
    false
    end
  end
end


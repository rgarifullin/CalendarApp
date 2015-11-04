class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:date].nil?
      @date = Date.today
    else
      @date = params[:date].to_date
    end

    @all_events = current_user.events
    @events = []
    @all_events.each do |event|
      @events << event if event.schedule.occurs_on?(@date)
    end
  end

  def new
    @user = current_user
    @event = @user.events.build
    @event.schedule = IceCube::Schedule.new
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def create
    @user = current_user
    @event = @user.events.build(event_params)
    create_schedule(@event)

    if @event.save
      flash[:notice] = 'New event created.'
      redirect_to user_events_path
    else
      render 'new'
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    create_schedule(@event)

    if @event.update_attributes(params.require(:event).permit(:title, :description, :recurrence, :schedule))
      flash[:notice] = 'Event updated successfully.'
      redirect_to user_events_path
    else
      render 'edit'
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy
  end

  def list
    if params[:search].nil?
      @events = current_user.events
    else
      @events = current_user.events.where('title = ?', params[:search])
    end

    @events = @events.paginate(page: params[:page], per_page: 10)
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :recurrence, schedule: [:start_time])
  end

  def create_schedule(event)
    case event_params[:recurrence]
      when 'daily'
        rule = IceCube::Rule.daily
      when 'weekly'
        rule = IceCube::Rule.weekly
      when 'monthly'
        rule = IceCube::Rule.monthly
      when 'yearly'
        rule = IceCube::Rule.yearly
      else
        rule = IceCube::Rule.new
    end

    event.schedule = IceCube::Schedule.new((event_params[:schedule]['start_time(1i)'].to_s+'.'+
                                            event_params[:schedule]['start_time(2i)'].to_s+'.'+
                                            event_params[:schedule]['start_time(3i)'].to_s).to_time)
    event.schedule.add_recurrence_rule rule unless event_params[:recurrence] == 'one-time'
  end
end

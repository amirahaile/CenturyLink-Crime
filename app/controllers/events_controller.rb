class EventsController < ApplicationController

  def create
    if (Event.fetch?) then
      incidents = Event.fetch

      incidents.each do |incident|
        if (Event.within_mile_radius?(incident)) then
          event = Event.new
          event.description = incident.initial_type_description
          event.datetime = incident.at_scene_time
          event.group = incident.initial_type_group
          event.zone = incident.zone_beat
          event.longitude = incident.longitude
          event.latitude = incident.latitude
          event.save
        end
      end
    end

    redirect_to maps_url
  end

  def show
    # TODO: Create scopes for event types & timeframes based on param queries
    # event_types = params[:event_types].split(",")
    # event_timeframe = params[:timeframe].split(",")

    @events = Event.all
    prepared_events = []
    @events.each do |event|
      json.push({
        group: event.group,
        description: event.description,
        datetime: event.datetime,
        zone: event.zone,
        longitude: event.longitude,
        latitude: event.latitude
        })
    end

    render json: prepared_events.to_json
  end
end

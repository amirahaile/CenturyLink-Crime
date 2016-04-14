class EventsController < ApplicationController

  def create
    if (fetch?) then
      incidents = Event.fetch

      incidents.each do |incident|
        if (Event.within_mile_radius?(incident)) then
          event = Event.new
          event.description = incidient["initial_type_description"]
          event.timestamp = incident["at_scene_time"]
          event.group = incident["initial_type_group"]
          event.zone = incident["zone_beat"]
          event.lng = incident["longitude"]
          event.lat = incident["latitude"]
          event.save
        end
      end
    end

    redirect_to map_url
  end
end

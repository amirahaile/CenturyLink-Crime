class EventsController < ApplicationController
  
  def create
    last_event = Event.last
    if (Time.now - last_event.time > 4) then
      incidents = self.fetch_events
      incidents.each do |incident|
        if (event.within_mile_radius?) then
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
  end

  # Helper Methods ---------------------------------------------------------------
  def fetch_events
    seattle_incidents = "3k2p-39jp"
    events = @socrata.get(seattle_incidents, {
      "$select" => ["initial_type_description", "at_scene_time",
                    "initial_type_group", "zone_beat",
                    "longitude", "latitude"],
      "$order" => "at_scene_time"
      })

    return events
  end
end

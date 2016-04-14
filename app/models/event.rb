class Event < ActiveRecord::Base

  # Validations ----------------------------------------------------------------
  validates :description, presence: true
  validates :timestamp, presence: true
  validates :group, presence: true
  validates :zone, presence: true, length: 2
  validates :lng, presence: true
  validates :lat, presence: true

  # Methods --------------------------------------------------------------------
  class Numeric
    def to_radius
      return self * Math::PI / 180
    end
  end

  def fetch?
    return true if Event.last.timestamp.nil?
    last_fetch_month = Event.last.timestamp[5..6].to_i
    last_fetch_day = Event.last.timestamp[8..9].to_i
    last_fetch_hour = Event.last.timestamp[-4..-3].to_i

    current_month = Time.now.month
    current_day = Time.now.day
    current_hour = Time.now.hour

    refresh_interval = 4 # hours

    if (last_fetch_month < current_month || last_fetch_day < current_day ||
       (current_hour - last_fetch_hour).abs > refresh_interval) then
      return true
    else
      return false
    end
  end

  def fetch
    seattle_incidents = "3k2p-39jp"
    events = @socrata.get(seattle_incidents, {
      "$select" => ["initial_type_description", "at_scene_time",
                    "initial_type_group", "zone_beat",
                    "longitude", "latitude"],
      "$order" => "at_scene_time"
      })

    return events
  end

  def within_mile_radius?(event)
    centuryLinkCoordinates = {lat: 47.593933, lng: -122.331539}

    earthRadius = 3958.75 # miles
    dlat = (centuryLinkCoordinates.lat - event.lat).to_radius
    dlng = (centuryLinkCoordinates - event.lng).to_radius
    sin_dlat = Math.sin(dlat / 2);
    sin_dlng = Math.sin(dlng / 2);

    # Haversine formula
    a = Math.pow(sin_dlat, 2) + Math.pow(sin_dlng, 2) *
        Math.cos(centuryLinkCoordinates.lat.to_radius) *
        Math.cos(event.lat.to_radius)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    distance = earthRadius * c;

    return distance < 1 ? true : false
  end
end

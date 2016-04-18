# Helper Method
class Float
  def to_radius
    self * Math::PI / 180
  end
end

class Event < ActiveRecord::Base

  # Validations ----------------------------------------------------------------
  validates :description, presence: true
  validates :datetime, presence: true
  validates :group, presence: true
  validates :zone, presence: true, length: {is: 2}
  validates :longitude, presence: true
  validates :latitude, presence: true

  # Scopes ---------------------------------------------------------------------
  def self.of_type(event_types)
    matching_events = []
    event_types.each do |type|
      matching_events << Event.select { |event| event.group == type }
    end

    matching_events
  end

  def self.within_mile_radius?(event)
    centuryLinkCoordinates = {lat: 47.593933, lng: -122.331539}

    earthRadius = 3958.75 # miles
    dlat = (centuryLinkCoordinates[:lat] - event.latitude.to_f).to_radius
    dlng = (centuryLinkCoordinates[:lng] - event.longitude.to_f).to_radius
    sin_dlat = Math.sin(dlat / 2);
    sin_dlng = Math.sin(dlng / 2);

    # Haversine formula
    a = (sin_dlat ** 2) + (sin_dlng ** 2) *
        Math.cos(centuryLinkCoordinates[:lat].to_radius) *
        Math.cos(event.latitude.to_f.to_radius)
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    distance = earthRadius * c;

    return distance < 1 ? true : false
  end

  # Methods --------------------------------------------------------------------
  def self.init_socrata
    @socrata ||= SODA::Client.new({:domain => "explore.data.gov",
                                   :app_token => "TaAEwamFxC5DPESYEnDDZlNp9"})
  end

  def self.fetch?
    self.init_socrata

    return true if Event.last.nil?
    last_fetch_month = Event.last.created_at.month
    last_fetch_day = Event.last.created_at.day
    last_fetch_hour = Event.last.created_at.hour

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

  def self.fetch
    client = SODA::Client.new({:domain => "data.seattle.gov"})
    events = client.get("https://data.seattle.gov/resource/3k2p-39jp.json",
    {
      "$select" => "initial_type_description, at_scene_time,
                    initial_type_group, zone_beat,
                    longitude, latitude",
      "$order" => "at_scene_time"
    })

    return events
  end
end

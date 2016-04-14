class Event < ActiveRecord::Base

  # Validations ----------------------------------------------------------------
  validates :description, presence: true
  validates :timestamp, presence: true
  validates :group, presence: true
  validates :zone, presence: true, length: 2
  validates :lng, presence: true 
  validates :lat, presence: true

  # Scopes ---------------------------------------------------------------------
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

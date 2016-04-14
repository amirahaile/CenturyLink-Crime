function initialize() {
  // Initialize map
  var centuryLinkCoordinates = {lat: 47.593933, lng: -122.331539};
  var map = createMap(centuryLinkCoordinates);

  // Draw 1 mile radius around CenturyLink Field
  var mileInMeters = 1609.34;
  var mileBorder = new google.maps.Circle({
    strokeColor: '#FF0000',
    strokeOpacity: 0.8,
    strokeWeight: 1,
    fillOpacity: 0,
    map: map,
    center: centuryLinkCoordinates,
    radius: mileInMeters
  });

  // Place a marker on CenturyLink Field
  var centuryLinkMarker = new google.maps.Marker({
    position: centuryLinkCoordinates,
    map: map,
    title: 'CenturyLink Field'
  });

  google.maps.event.addDomListener(window, 'load', initialize);
}

function createMap(coordinates) {
  var mapOptions = {
    center: coordinates,
    zoom: 14,
    scrollwheel: false,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };

  var googleMap = new google.maps.Map(document.getElementById("map"), mapOptions);
  return googleMap;
}

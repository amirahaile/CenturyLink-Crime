/**
 * onAdd is called when the map's panes are ready and the overlay has been
 * added to the map.
 */
CrimeOverlay.prototype.onAdd = function() {

  var div = document.createElement('div');
  div.style.borderStyle = 'none';
  div.style.borderWidth = '0px';
  div.style.position = 'absolute';
  div.setAttribute("id", "data-viz");

  // Add the element to the "overlayLayer" pane.
  var panes = this.getPanes();
  panes.overlayLayer.appendChild(div);
};

CrimeOverlay.prototype.draw = function() {
  // To peg the overlay to the correct position and size,
  // we need to retrieve the projection from the overlay.
  var overlayProjection = this.getProjection();

  // Create visualization for crime data
  d3.json("/events/show/", function(data) {
    var padding = 30;
    var layerDiv = document.getElementById("data-viz");

    // Create markers
    var marker = layerDiv.selectAll("svg")
                        // TODO: Refactor once JSON format is determined.
                         .data(d3.entries(data))
                         .each(transform_marker)
                         .enter().append("svg:svg")
                         .each(transform_marker)
                         .attr("class", "marker");

    // Represent them with circles
    marker.append("svg:circle")
          .transition()
          .delay(1000)
          // TODO: Size circles according to # of crimes within 1 block
          .attr("r", function(d) {
            		return Math.sqrt(1 * 0.00045 + padding);
               })
          .attr("cx", padding)
          .attr("cy", padding)
          .style("fill", "#ccc");

    // Add a label.
    marker.append("svg:text")
          .transition()
          .delay(1000)
          .attr("x", padding - 3)
          .attr("y", padding)
          .attr("dy", ".45em")
          .attr("dx", ".4em")
          .text(function(data) { return data.group.titlecase; });

    function transform_marker(data) {
      var latlng = new google.maps.LatLng(data.latitude, data.longitude);
      var pxCoordinates = overlayProjection.fromLatLngToDivPixel(latlng);
      var marker = d3.select(this);
      return marker.style("left", (d.x - padding) + "px")
                   .style("top", (d.y - padding) + "px");
    }
  });
};

# CenturyLink Field Crime

Ultimately I wanted to visualize the crime data, categorized by type and time, in relation to CenturyLink Field. The idea was that a user who frequents events held at CenturyLink Field could visualize the type of crime they may be susceptible to while attending the event.

A Google map, centered on CenturyLink Field, would be dotted with circles representing an instance of crime (markers created by D3 would be attached to a Google map overlay placed on top of the map).

Improvements
* Consolidate nearby, similar crimes into a single circle whose radius grows with the number of crimes it represents (powered by D3).
* A time scale that populates the map with crime only committed at that time of day/within that time frame (filtered by scopes on the RoR Event model).
* Retrieve data on the events hosted by CenturyLink Field and quickly visualize crimes that have occurred during that timeframe (or did occur within that time frame if the event has passed). 

Technologies Used
* Ruby on Rails
* Google Maps Javascript API
* D3.js

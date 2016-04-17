class MapsController < ApplicationController
  def index
    @event_types = Event.pluck(:group).uniq!
  end
end

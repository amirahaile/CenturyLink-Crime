class MapsController < ApplicationController
  include MapsHelper

  def index
    @event_types = Event.pluck(:group).uniq!
    @events = Event.all
  end

  def show
    event_type = match_event_type(params[:event_type])
    @events = Event.where("group = ?", event_type)
    redirect_to map_url(event_type)
  end

  private

  def match_event_type(event_link)
    event_string = event_link.downcase.gsub("-", " ").delete("-").gsub(",", " ")
    event_types = Event.pluck(:group).uniq!
    event_types.each do |event|
      sanitized_event = event.downcase.delete(",").delete("-").gsub("/", " ")
      sanitized_event = sanitized_event.split(" ")
      return format_link(event) if sanitized_event == event_string.split(" ")
    end

    return nil
  end
end

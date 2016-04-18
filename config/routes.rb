Rails.application.routes.draw do

  root 'events#create'

  get "/maps" => "maps#index"
  get "/map/:event_type" => "maps#show", as: :map

  # TODO: APIs for filtering events by type & timeframes
  # NOTE: Used by Javascript functions to retrieve JSON
  get "/events/show/:event_type" => "events#show"
end

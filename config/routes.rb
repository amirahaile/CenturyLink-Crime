Rails.application.routes.draw do

  root 'events#create'

  get "/maps" => "maps#index"
  get "/map/:event_type" => "maps#show", as: :map
end

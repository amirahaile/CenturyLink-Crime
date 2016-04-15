Rails.application.routes.draw do

  root 'events#create'

  get "/map" => "map#index"

end

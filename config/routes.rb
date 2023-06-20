Rails.application.routes.draw do

  post "/sessions" => "sessions#create"
  resources :users  
  
  resources :plants
  resources :collected_plants
end

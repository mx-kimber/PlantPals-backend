Rails.application.routes.draw do

  resource :sessions, only: [:create, :destroy]
  resources :users  
  
  resources :plants
  resources :collected_plants
  resources :schedules
end

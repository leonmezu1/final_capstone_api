Rails.application.routes.draw do
  resources :registrations, only: %i[create]
  resources :sessions, only: %i [create]
end

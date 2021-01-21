Rails.application.routes.draw do
  resources :sessions, only: %i[create]
  resources :registrations, only: %i[create]
end

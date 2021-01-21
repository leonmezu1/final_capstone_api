Rails.application.routes.draw do
  resources :sessions, only: %i[create]
  resources :tokens, only: %i[create]
end

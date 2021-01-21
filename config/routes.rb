Rails.application.routes.draw do
  post :login, to: 'sessions#login'
  get :auto_login, to: 'sessions#auto_login'
  resources :registrations, only: %i[create]
end

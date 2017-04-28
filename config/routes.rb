Rails.application.routes.draw do
  root to: 'home#index'
  get 'home/index'

  resources :access_requests
  resources :tokens
end

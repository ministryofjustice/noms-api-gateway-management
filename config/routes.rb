Rails.application.routes.draw do
  root to: 'home#index'
  get 'home/index'

  resources :access_requests, except: [:edit, :update]
  resources :tokens
end

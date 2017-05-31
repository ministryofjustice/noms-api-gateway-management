Rails.application.routes.draw do
  root to: 'access_requests#new'

  resources :access_requests, except: [:edit, :update]
  resources :tokens
end

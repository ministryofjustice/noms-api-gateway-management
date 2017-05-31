Rails.application.routes.draw do
  root to: 'access_requests#new'

  resources :access_requests, only: [:new, :create, :show]

  namespace :admin do
    root to: 'tokens#index'

    resources :tokens
    resources :access_requests, except: [:new, :create, :edit, :update]
  end
end

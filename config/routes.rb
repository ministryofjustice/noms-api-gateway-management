Rails.application.routes.draw do
  root to: 'access_requests#new'

  resources :access_requests, only: [:new, :create, :show]

  namespace :admin do
    root to: 'access_requests#index'

    resources :tokens, except: [:edit, :update, :destroy] do
      put :revoke, on: :member
      patch :revoke, on: :member
    end
    resources :access_requests, except: [:new, :create, :edit, :update]
  end

  namespace :api, format: :json do
    resources :tokens, only: [:index]
  end
end

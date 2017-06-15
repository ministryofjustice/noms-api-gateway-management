Rails.application.routes.draw do
  root to: 'access_requests#new'

  resources :access_requests, only: [:new, :create, :show]
  get 'access_request/confirmation', to: 'access_requests#show'

  resources :tokens, only: [:new, :update]

  namespace :admin do
    root to: 'access_requests#index'

    resources :tokens, except: [:edit, :update, :destroy] do
      put :revoke, on: :member
      patch :revoke, on: :member
    end
    resources :access_requests, except: [:new, :create, :edit, :update]
  end

  namespace :api, format: :json do
    resources :tokens, only: [:revoked] do
      get :revoked, on: :collection
    end
  end
end

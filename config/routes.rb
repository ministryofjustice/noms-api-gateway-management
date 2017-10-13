Rails.application.routes.draw do
  root to: 'environments#index'

  resources :access_requests, only: [:new, :create, :show]
  get 'access_request/confirmation', to: 'access_requests#show'

  resources :tokens, only: [:new, :update]
  # This is the callback url we return to after signing in with moj-signon
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    root to: 'access_requests#index'

    resources :tokens, except: [:edit, :update, :destroy] do
      put :revoke, on: :member
      patch :revoke, on: :member
    end
    resources :access_requests, except: [:new, :create, :edit, :update]

    resources :environments, only: [
      :index, :show, :new, :create, :edit, :update, :destroy
    ]
  end

  namespace :api, format: :json do
    resources :tokens, only: [:revoked] do
      get :revoked, on: :collection
    end
  end
end

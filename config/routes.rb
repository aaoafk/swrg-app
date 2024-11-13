Rails.application.routes.draw do
  get "steps/show"
  get "steps/update"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Static pages
  resources :pages, only: [] do
    collection do
      get :home
    end
  end
  root "pages#home"

  resource :session, only: [ :new, :create ] do
    get :validate
    post :verify
  end

  # Application pages
  # All authenticated routes under /app namespace
  namespace :app do
    get "onboarding/show"
    get "onboarding/update"
    root to: "dashboard#show" # This becomes our post-login landing page

    # Other app routes can go here
    resources :groups, only: [ :index, :show ]
    resources :meetings, only: [ :index, :show ]
    resource :profile, only: [ :show, :edit, :update ]

    # Onboarding routes
    namespace :onboarding do
      root to: 'steps#show'
      resource :steps, only: [:show, :update] do
        collection do
          get :complete_profile
          get :select_group
        end
      end
    end
  end
end

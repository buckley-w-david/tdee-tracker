Rails.application.routes.draw do
  namespace :fitness do
    resources :workouts
    resources :exercises
    resources :routines
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "days#index"

  resource :user, path: "profile", only: %i[edit update]

  resource :import, only: %i[new create]

  resources :days do
    collection do
      get "by_date/:date", action: "by_date", as: :by_date
    end

    resources :meals, module: :day do
      collection do
        get "copy"
      end
    end
  end

  get "admin/import", controller: "admin", action: "import"
  post "admin/import", controller: "admin", action: "import_foods"

  post "foods/search", controller: "food_search", action: "search", as: :food_search

  resources :goals

  get "calendar", controller: "calendar", action: "index"

  resource "integrations"

  scope "/integrations/withings", as: "withings" do
    get "authorize", action: "authorize", controller: "integrations/withings"
    get "register", action: "register", controller: "integrations/withings"
    get "revoke", action: "revoke", controller: "integrations/withings"
  end

  scope "/integrations/google", as: "google" do
    get "connect", action: "connect", controller: "integrations/google"
    get "oauth", action: "register", controller: "integrations/google"
  end

  get "stats", controller: "stats", action: "index"

  resources :workouts do
    collection do
      get "by_date/:date", action: "by_date", as: :by_date
    end
  end
end

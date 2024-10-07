Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "days#index"

  resources :days do
    collection do
      get "import"
      post "import", action: "import_values"
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

  get "withings", controller: "withings", action: "register"

  get "google/connect", controller: "google", action: "connect"
  get "google/oauth", controller: "google", action: "register"

  get "stats", controller: "stats", action: "index"
end

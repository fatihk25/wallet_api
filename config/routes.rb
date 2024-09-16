Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :entities, only: [ :index, :show, :create, :update, :destroy ]

  resources :stocks, only: [ :index, :show, :create, :update, :destroy ] do
    collection do
      get "search"
    end
  end


  resources :wallets, only: [ :show ] do
    member do
      post :deposit
      post :withdraw
    end
  end

  resources :transactions, only: [ :create ]

  post "/login", to: "sessions#create"
  post "/logout", to: "sessions#destroy"
end

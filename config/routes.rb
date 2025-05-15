Rails.application.routes.draw do
  resources :reservations
  resources :notifications do
    collection do
      get :check_status
    end
  end
  resources :members
  resources :librarians
  resources :books
  resources :authors
  resources :borrowings

  post "/login", to: "sessions#create"

  # Health check ruta
  get "up" => "rails/health#show", as: :rails_health_check
end

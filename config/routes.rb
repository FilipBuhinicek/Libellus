Rails.application.routes.draw do
  resources :reservations
  resources :notifications
  resources :members
  resources :librarians
  resources :books
  resources :authors
  resources :borrowings

  post "/login", to: "sessions#create"

  # Health check ruta
  get "up" => "rails/health#show", as: :rails_health_check
end

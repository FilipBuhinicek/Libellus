Rails.application.routes.draw do
  resources :reservations
  resources :notifications
  resources :members
  resources :librarians
  resources :books
  resources :authors
  resources :borrowings

  # Health check ruta
  get "up" => "rails/health#show", as: :rails_health_check

  # Root ruta (možeš ju promijeniti po potrebi)
  # root "home#index"
end

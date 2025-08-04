Rails.application.routes.draw do
  root "sessions#new"

  resources :photos, only: [:index, :new, :create, :destroy]
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end

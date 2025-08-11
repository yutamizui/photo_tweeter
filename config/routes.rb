Rails.application.routes.draw do
  root "sessions#new"

  resources :photos, only: [:index, :show, :new, :create, :destroy] do
    post :tweet, on: :member
  end

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "oauth/callback", to: "oauth#callback" 
end

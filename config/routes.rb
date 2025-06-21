Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "flats#index"

  resources :flats, only: %i[index show] do
    collection do
      get :autocomplete
    end

    resources :requests, only: %i[new create]
  end

  resources :requests, only: %i[index show edit update]
end

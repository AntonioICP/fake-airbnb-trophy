Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

    root to: 'flats#index'
  resources :flats, only: [:index, :show] do
    resources :requests, only: [:new, :create, :update, :edit]
  end
end

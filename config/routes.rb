Rails.application.routes.draw do
  root "home#index"

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  get "/signup" => "accounts#new"
  post "/signup" => "accounts#create"

  resource :account do
    put :favorite_cinema
    get :edit_password
  end

  resources :movies, only: [:show, :index]

  resources :cinemas, only: [:index, :show] do
    resources :movies, only: [:show]
  end
end

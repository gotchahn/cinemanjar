Rails.application.routes.draw do
  root "home#index"

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  get "/signup" => "accounts#new"
  post "/signup" => "accounts#create"

  resource :account do
    put :favorite_cinema
  end

  resources :movies do
    get :upcoming, on: :collection
    get :showing, on: :collection
  end

  resources :cinemas, only: [:index, :show] do
    resources :movies, only: [:show]
  end
end

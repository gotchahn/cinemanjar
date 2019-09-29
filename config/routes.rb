Rails.application.routes.draw do
  root "home#index"

  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  get "/signup" => "accounts#new"
  post "/signup" => "accounts#create"

  resource :account
  resources :movies do
    get :upcoming, on: :collection
    get :showing, on: :collection
  end
end

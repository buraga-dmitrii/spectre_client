Rails.application.routes.draw do
  resources :transactions, only: [:index]
  resources :accounts, only: [:index]
  resources :logins, only: [:index, :create, :destroy]
  devise_for :users
  
  root to: "logins#index"
  get :login_refresh,   to: 'logins#login_refresh'
  get :login_reconnect, to: 'logins#login_reconnect'
  get :update_logins,   to: 'logins#update_logins'
end

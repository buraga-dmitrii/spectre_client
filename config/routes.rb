Rails.application.routes.draw do
  resources :transactions, only: [:index]
  resources :accounts
  resources :logins
  devise_for :users
  
  root to: "logins#index"
  get :login_create, to: 'logins#login_create'
  get :login_refresh, to: 'logins#login_refresh'
  get :login_reconnect, to: 'logins#login_reconnect'
  get :update_logins, to: 'logins#update_logins'
  get :accounts_refresh, to: 'accounts#refresh'
end

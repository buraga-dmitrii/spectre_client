Rails.application.routes.draw do
  resources :transactions
  resources :accounts
  resources :logins
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "home#index"
  get :login_create, to: 'logins#login_create'
  get :login_refresh, to: 'logins#login_refresh'
  get :login_reconnect, to: 'logins#login_reconnect'
  get :accounts_refresh, to: 'accounts#refresh'
end

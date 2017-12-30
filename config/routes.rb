Rails.application.routes.draw do
  resources :logins
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: "home#index"
  get :login_create, to: 'home#login_create'
end

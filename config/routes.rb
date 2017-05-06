Rails.application.routes.draw do
  
  resources :ratings
  resources :payments
  resources :user_docs
  mount_devise_token_auth_for 'User', at: 'auth'
  
  resources :hiring_responses
  resources :hiring_requests
  resources :hospitals
  resources :users
  resources :post_codes
  resources :staffing_responses
  resources :staffing_requests

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

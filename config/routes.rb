Rails.application.routes.draw do
  get 'sessions/new'

  resources :transactions
  resources :cards
  resources :users
  resources :stores
  resources :card_products
  root to: 'stores#index'
  get    '/signup',  to: 'stores#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

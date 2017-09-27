Rails.application.routes.draw do
  get 'sessions/new'

  resources :transactions
  resources :users
  resources :stores
  resources :card_products
  resources :clients do
    resources :cards
  end

  root to: 'stores#index'
  get    '/signup',  to: 'stores#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

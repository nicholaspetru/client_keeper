Rails.application.routes.draw do
  get 'sessions/new'

  resources :users
  resources :stores
  resources :card_products
  resources :clients do
    resources :cards, except: :create
    resources :transactions
  end

  get  '/transactions/begin' => 'transactions#begin'
  post '/transactions/begin' => 'transactions#begin_with_client'
  post '/clients/:client_id/transactions/new' => 'transactions#create'
  post '/clients/:client_id' => 'clients#activate'
  post '/clients/:client_id/cards/new' => 'cards#create'
  post '/clients/:client_id/cards' => 'cards#add_funds', as: 'client_cards_add_funds'

  root to: 'clients#index'
  get    '/signup',  to: 'stores#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

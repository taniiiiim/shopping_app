Rails.application.routes.draw do

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/users/:id/exit', to: 'users#exit'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/search', to: 'search#new'

  get '/orders/:id/cancel', to: 'orders#cancel'

  post '/cart', to: 'cart#create'
  get '/cart/:id', to: 'cart#show'
  get "/cart/:id/edit", to: 'cart#edit'
  post "/cart/:id/edit", to: 'cart#edit'
  patch "/cart/:id", to: 'cart#update'
  delete '/cart/:id', to: 'cart#destroy'

  resources :users
  resources :products
  resources :orders
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :stocks,              only: [:create, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

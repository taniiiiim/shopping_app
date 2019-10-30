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
  post '/search', to: 'search#create'

  post '/cart', to: 'cart#create'
  delete 'cart', to: 'cart#destroy'

  resources :users
  resources :products
  resources :orders

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  get '/registration', to: 'users#new'

  resources :users, only: [:create]
  resources :parties, only: [:new, :create]

  get '/dashboard', to: 'dashboard#index'

  get '/discover', to: 'movies#discover'
  get '/movies', to: 'movies#index'
  get '/movies/:api_ref', to: 'movies#show', as: :movie

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#delete'

  resources :friendships, only: [:create, :update, :destroy]
end

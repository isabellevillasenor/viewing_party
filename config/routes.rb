Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  get '/registration', to: 'users#new'

  resources :users, only: [:create]

  get '/dashboard', to: 'dashboard#index'

  get '/discover', to: 'movies#discover'
  get '/movies', to: 'movies#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
end

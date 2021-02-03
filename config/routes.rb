Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  #make this a show so an id can be passed via params
  resources :dashboard, only: [:index]

end

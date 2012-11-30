Weightyplates::Application.routes.draw do
  devise_for :users
  use_doorkeeper

  resources :dashboard
  resources :exercises

  match "*path", :to => "application#routing_error"

  root to: 'home#index'

end
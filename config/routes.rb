Weightyplates::Application.routes.draw do
  devise_for :users
  use_doorkeeper

  resources :dashboard
  resources :exercises



  root to: 'home#index'

end
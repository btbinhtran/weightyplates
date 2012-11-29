Weightyplates::Application.routes.draw do
  devise_for :users

  resources :dashboard
  resources :exercises



  root to: 'home#index'

end
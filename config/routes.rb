Weightyplates::Application.routes.draw do
  devise_for :users
  resources :dashboard


  namespace :user do
    root :to => "dashboard#index"
  end

  root to: 'home#index'

end
Weightyplates::Application.routes.draw do
  devise_for :users,
             :path_names => { :sign_in => 'login', :sign_out => 'logout'}

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  resources :users

  use_doorkeeper

  resources :dashboard
  resources :exercises, only: [:index]

  match "*path", :to => "application#routing_error"

  root to: 'home#index'

end
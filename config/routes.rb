Weightyplates::Application.routes.draw do

  devise_for :users,
             :path_names => { :sign_in => 'login', :sign_out => 'logout'}


  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    post '/logout' => 'devise/sessions#destroy'
    get 'users/logout' => 'devise/sessions#destroy'
  end

  resources :users

  use_doorkeeper

  resources :dashboard, only: [:index]
  scope '/api' do
    resources :exercises, only: [:index]
    resources :workouts do
      resources :workout_entries, only: [:create, :update, :destroy] do
        resources :entry_details, only: [:create, :update, :destroy]
      end
    end
  end

  get '/calculator' => 'calculator#index'

  match "*path", :to => "application#routing_error"

  root to: 'home#index'

end
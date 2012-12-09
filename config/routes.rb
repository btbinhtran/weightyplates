Weightyplates::Application.routes.draw do
  devise_for :users,
             :path_names => { :sign_in => 'login', :sign_out => 'logout'}

  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    delete '/logout' => 'devise/sessions#destroy'
  end

  resources :users

  use_doorkeeper

  resources :dashboard, only: [:index]
  scope '/api' do
    resources :exercises, only: [:index]
    resources :workouts do
      resources :workout_entries, only: [:create, :update, :destroy] do
        resources :entry_details, only: [:create, :update, :destroy] do

        end
      end
    end
  end

  match "*path", :to => "application#routing_error"

  root to: 'home#index'

end
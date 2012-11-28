Weightyplates::Application.routes.draw do
  #devise_for :users
  #resources :users

  devise_for :users,
             :controllers => { :registrations => "users/registrations",
                               :confirmations => "users/confirmations",
                               :sessions => 'devise/sessions'},
             :skip => [:sessions] do
    get '/signin'   => "devise/sessions#new",       :as => :new_user_session
    post '/signin'  => 'devise/sessions#create',    :as => :user_session
    get '/signout'  => 'devise/sessions#destroy',   :as => :destroy_user_session
    get "/signup"   => "user/registrations#new",   :as => :new_user_registration
  end

  devise_scope :user do
    #match "/some/route" => "some_devise_controller"
    root to: 'devise/registrations#new'
  end



  #get "dashboard/index"
  #root to: 'dashboard#index'

end

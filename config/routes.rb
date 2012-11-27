Weightyplates::Application.routes.draw do
  devise_for :users

  get "dashboard/index"

  root to: 'dashboard#index'
end

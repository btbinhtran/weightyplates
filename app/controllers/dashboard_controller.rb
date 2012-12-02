class DashboardController < ApplicationController
  layout 'dashboard'
  before_filter :custom_user_auth

  def custom_user_auth
    unless user_signed_in?
      redirect_to controller: 'home', action: 'index'
    end
  end

  def index
  end

end

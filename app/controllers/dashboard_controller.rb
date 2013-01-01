class DashboardController < ApplicationController
  layout 'dashboard'
  before_filter :custom_user_auth

  def custom_user_auth
    unless user_signed_in?
      redirect_to controller: 'home', action: 'index'
    end
  end


  def index
    @preload_data = 'some data in advance'
    render :layout => 'dashboard'
  end

end

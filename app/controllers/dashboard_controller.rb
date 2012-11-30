class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    #unless user_signed_in?
    #  redirect_to :controller => 'home', :action => 'index'
    #end
  end
end

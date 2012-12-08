class WorkoutsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!


  def index
    respond_with(current_user.workouts)
  end

  def destroy
    respond_with(current_user.workouts.destroy(params[:id]))
  end
end

class WorkoutsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!



  def index
    respond_with(current_user.workouts)
  end

  def show
    respond_with(current_user.workouts.find(params[:id]))
  end

  def create
    puts "params are #{params}"
    respond_with(current_user.workouts.create(params[:workout]))
  end

  def update
    @workout = current_user.workouts.find(params[:id])
    if @workout.update_attributes(params[:workout])
      render json: @workout, status: :ok
    else
      render json: @workout.errors, status: :unprocessable_entity
    end
  end

  def destroy
    respond_with(current_user.workouts.destroy(params[:id]))
  end
end

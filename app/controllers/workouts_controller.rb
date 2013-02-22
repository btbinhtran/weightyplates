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
    #information = request.raw_post
    #data_parsed = JSON.parse(information)

    p params[:workout]
    #hash = JSON.parse(params[:workout])
    #p hash

    #workout_param = params[:workout].except("workout_entry")

    current_user_workouts = current_user.workouts
    params[:workout].each do |k,v|
      @workout = current_user_workouts.create(v)

      if @workout.save
        render :json => @workout
      else
        render :json => { :errors => @workout_entry.errors.full_messages }, :status => 422
      end
    end



    #respond_with(current_user.workouts.create(params[:workout]))
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



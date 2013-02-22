class WorkoutEntriesController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  def create
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      respond_with(@workout.workout_entries.create(params[:workout_entry]))
    else
      render json: { error: "Invalid workout." }, status: :unprocessable_entity
    end
  end

  def update
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      @workout_entry = @workout.workout_entries.find(params[:id])
      if @workout_entry.update_attributes(params[:workout_entry])
        render json: @workout_entry, status: :ok
      else
        render json: @workout_entry.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid workout." }, status: :unprocessable_entity
    end
  end


  def destroy
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      respond_with(@workout.workout_entries.destroy(params[:id]))
    else
      render json: { error: "Invalid workout." }, status: :unprocessable_entity
    end
  end
end

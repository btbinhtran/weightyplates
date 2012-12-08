class WorkoutEntriesController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  def create
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      params[:workout_entry][:workout_id] = @workout.id if params[:workout_entry]
      respond_with(@workout.workout_entries.create(params[:workout_entry]))
    end
  end

  def update

  end

  def destroy
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      respond_with(@workout.workout_entries.destroy(params[:id]))
    end
  end
end

class EntryDetailsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  def create
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      @workout_entry = @workout.workout_entries.find(params[:workout_entry_id])
      if @workout_entry
        respond_with(@workout_entry.entry_details.create(params[:entry_detail]))
      else
        render json: { error: "Invalid workout entry." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid workout." }, status: :unprocessable_entity
    end
  end

  def update
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      @workout_entry = @workout.workout_entries.find(params[:id])
      if @workout_entry
        @entry_detail = @workout_entry.entry_details.find(params[:id])
        if @entry_detail.update_attributes(params[:entry_detail])
          render json: @entry_detail, status: :ok
        else
          render json: @entry_detail.errors, status: :unprocessable_entity
        end
      else
        render json: { error: "Invalid workout entry." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid workout." }, status: :unprocessable_entity
    end
  end


  def destroy
    @workout = current_user.workouts.find(params[:workout_id])
    if @workout
      @workout_entry = @workout.workout_entries.find(params[:workout_entry_id])
      if @workout_entry
        respond_with(@workout_entry.entry_details.destroy(params[:id]))
      else
        render json: { error: "Invalid workout entry." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid workout." }, status: :unprocessable_entity
    end
  end
end

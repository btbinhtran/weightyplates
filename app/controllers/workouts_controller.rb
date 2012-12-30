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

    #respond_with(current_user.workouts.create(params[:workout]))
    def workout_Fields_Satisfy(backup_orig_params)
      puts "ok save"
      @workout = current_user.workouts.first
      #puts @workout

      puts "can it reference the backup variable?"
      backup_orig_params.delete("unit")
      backup_orig_params.delete("name")
      backup_orig_params[:workout_entry][:workout_id] = @workout[:id]

      puts backup_orig_params

      puts "workout_entries"

      puts backup_orig_params
      puts backup_orig_params[:workout_entry]
      #@workout.workout_entries.create(backup_orig_params)

      @user_workout = current_user.workouts.find(@workout[:id])

      puts @user_workout

      @user_workout.workout_entries.create(backup_orig_params[:workout_entry])



        #puts @instance_variable = Workout.all

        #puts @another_variable = WorkoutEntry.all


    end

    params_copy = params[:workout]
    backup_orig_params = params_copy.dup
    puts "the params in a variable"
    puts params_copy

    puts 'delete portion of params'
    params_copy.delete("workout_entry")

    puts "does the params have deleted key"
    puts params_copy



    respond_with(current_user.workouts.create(params[:workout]), :callback => workout_Fields_Satisfy(backup_orig_params))

    puts "is it backup still good?"
    puts backup_orig_params
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

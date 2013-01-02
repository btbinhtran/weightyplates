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

    puts "the params are "
    puts params[:workout]

    #only executes when workout is successfully created
    def workout_Fields_Satisfy(backup_orig_params)

      #the first actually references the newest created workout
      @workout = current_user.workouts.first

      #create the workout_entry
      if @workout
        #backup is formatted as {"unit"=>"kg", "name"=>"a name", "workout_entry"=>{"exercise_id"=>"1", "workout_id"=>""}}
        #but only needs workout_entry, so delete the others
        backup_orig_params.delete("unit")
        backup_orig_params.delete("name")

        #assign the workout id to the workout_entry
        backup_orig_params[:workout_entry][:workout_id] = @workout[:id]

        @workout.workout_entries.create(backup_orig_params[:workout_entry])

        return
      end
    end

    #params is the original params
    #formatted as {"unit"=>"kg", "name"=>"a name", "workout_entry"=>{"exercise_id"=>"1", "workout_id"=>""}}

    #backup_orig_params is a shallow copy for backup
    backup_orig_params = params[:workout].dup unless params[:workout].nil?

    #need to remove workout_entry to be able to write workout
    params[:workout].delete("workout_entry")

    #the callback will create the workout_entry for the given workout
    respond_with(current_user.workouts.create(params[:workout]), :callback => workout_Fields_Satisfy(backup_orig_params))


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

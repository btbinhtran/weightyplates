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

      #backup is formatted as {"unit"=>"kg", "name"=>"a name", "workout_entry"=>{"exercise_id"=>"1", "workout_id"=>""}}
      #but only needs workout_entry, so delete the others
      backup_orig_params.delete("unit")
      backup_orig_params.delete("name")

      ##puts "deleted result"
      puts "initial backup"
      another_backup = backup_orig_params.dup
      puts another_backup

      #puts backup_orig_params[:workout_entry]

      #assign the workout id to each of the workout_entry
      backup_orig_params[:workout_entry].each do |workout_number, param|
        param.delete(:entry_detail)
        puts "getting a specific item"
        puts param
        puts "monitor another backup"
        puts another_backup

        param[:workout_id] = @workout[:id]
      end

      #create the each workout_entry
      backup_orig_params[:workout_entry].each_value do |value|

        @workout.workout_entries.create(value)
      end

      puts "another backup is "
      puts another_backup


      return

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

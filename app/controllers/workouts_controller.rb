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

    #check for existence of workout param before continuing
    if params[:workout]
      #array to check param against
      require_keys = %w(unit name note workout_entry)
      unit_value = %w(kg lb)
      unit_is_valid = nil
      name_exist = nil
      #an array to contain the information about the param
      key_cond = []
      #should have only one workout
      params[:workout].each do |key, value|
        #gather information about the param
        key_cond.push(require_keys.include? key)
        if key == 'unit'
          if value == unit_value[0] || value == unit_value[1]
            unit_is_valid = true
          else
            unit_is_valid = false
          end
        end

        if key == 'name'
          name_exist = true
        end

        #should have at least one exercise for a workout
        if key == 'workout_entry'
          puts 'workout entry'
          params[:workout][:workout_entry].each do |k,v|
            puts k
            puts v
          end
        end

      end

      #checking keys for existence
      if key_cond.length == require_keys.length
        #param must have all the necessary keys
        if key_cond.count(true) == key_cond.size
          puts "all required fields present"
        end
        if unit_is_valid == true
          puts 'unit is valid'
        end
        if name_exist == true
          puts 'name exists'
        end
    end

end

    respond_with(current_user.workouts.create(params[:workout]))
=begin
    #params is the original params
    #formatted as {"unit"=>"kg", "name"=>"a name", "workout_entry"=>{"exercise_id"=>"1", "workout_id"=>""}}

    #backup_orig_params is a shallow copy for backup
    backup_orig_params = params[:workout].dup unless params[:workout].nil?

    #need to remove workout_entry to be able to write workout
    params[:workout].delete("workout_entry")

    #the callback will create the workout_entry for the given workout
    respond_with(current_user.workouts.create(params[:workout]), :callback => workout_Fields_Satisfy(backup_orig_params))
=end
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

  private

=begin
#only executes when workout is successfully created
  def workout_Fields_Satisfy(backup_orig_params)

    #render json: @workout.errors, status: :unprocessable_entity

    @workout_created = true
    #the first actually references the newest created workout
    @workout = current_user.workouts.first

    #backup is formatted as {"unit"=>"kg", "name"=>"a name", "workout_entry"=>{"exercise_id"=>"1", "workout_id"=>""}}
    #but only needs workout_entry, so delete the others
    backup_orig_params.delete("unit")
    backup_orig_params.delete("name")

    #puts backup_orig_params[:workout_entry]

    @create_details = true
    backup_orig_params[:workout_entry].each do |workout_number|
      #puts "evaluating workout entry"
      #puts workout_number
      workout_number[:workout_id] = @workout[:id]
      if workout_number[:workout_entry_number].nil? || workout_number[:exercise_id].nil?
        @workout.destroy
        @create_details = false
        @workout_created = false
      end

    end

    if @create_details == true

      backup_orig_params[:workout_entry].each do |value|
        workout_entry_with_entry_details = value.dup

        value.delete("entry_detail")


        @workout.workout_entries.create(value)
        #puts @workout.workout_entries

        @workout_entry = @workout.workout_entries.first

        workout_entry_with_entry_details[:entry_detail].each do |workout_detail_number|

          #create the entry details, assuming all fields are valid; loop below removes if invalid
          @workout_entry.entry_details.create(:set_number => workout_detail_number[:set_number], :weight => workout_detail_number[:weight], :reps => workout_detail_number[:reps])

          #delete the workout and entry for missing details
          workout_detail_number.each do |key, value|
            if value.nil?
              @workout.destroy
              @workout_created = false

            end
          end


        end
      end

    end

    return




  end
=end

end



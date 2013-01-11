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
      another_backup = backup_orig_params.clone
      puts another_backup

      #puts backup_orig_params[:workout_entry]

      #assign the workout id to each of the workout_entry
      backup_orig_params[:workout_entry].each do |workout_number, param|
        param[:workout_id] = @workout[:id]
      end

      some_copy = nil
      workout_details = nil

      #create the each workout_entry
      backup_orig_params[:workout_entry].each_value do |value|
        puts "almost create"
        workout_details = value.dup
        value.delete("entry_detail")

        puts value
        @workout.workout_entries.create(value)
        @workout_entry = @workout.workout_entries.first

        puts "the defined workout_entry"
        puts @workout_entry

      end

      puts "the copied value"
      puts workout_details



      puts "workout entry"
      workout_details.each do |workout_detail_number, param|
        puts "attempt workout details"
        #puts param.fetch("entry_detail")
        if param.kind_of?(Hash)
          param.each_value do |value|
            puts "workout details now"
            #puts value

            #puts value.fetch("weight")
            #converted_hash = Hash[*value.to_a.flatten.map(&:to_i)]
            #puts converted_hash
=begin
            modifiedHash = Hash[ value.map{ |a, b| [ a,
                                        begin
                                          Integer b
                                        rescue ArgumentError
                                          b
                                        end ] } ]
=end
            #puts modifiedHash
            ##weightValue = modifiedHash.fetch("weight").to_f
            ##modifiedHash["weight"] = weightValue

            #puts modifiedHash

            #@workout_entry.entry_details.create(modifiedHash)

            #puts "now the defined workout_entry is"
            #puts @workout_entry

            #puts "does it have any entry details"
            #puts @workout_entry.entry_details

            puts value
            @workout_entry.entry_details.create(value)
            #@workout_entry.entry_details.create({"weight"=>"4213", "reps"=>"8", "set_number"=>"1"})
            #puts value
            value.each_value do |inner_value|
              #puts inner_value
              #@workout_entry.entry_details.create(inner_value)
            end


            #

            #puts @workout_entries
            #puts "workout details get info"
            #puts @workout_entries.entry_details
            #puts .entry_details.create(value)
            #puts value

          end

        end

      end
      #puts @workout_entry[:workout_id]


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

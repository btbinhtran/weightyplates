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
    #creating the workout
    params[:workout] = {"unit"=>"kg", "name"=>"2013-02-24T21:27:57", "note"=>"", "workout_entries_attributes"=>{"0"=>{"workout_entry_number"=>"1", "exercise_id"=>"1", "entry_details"=>{"0"=>{"set_number"=>"1", "weight"=>"12", "reps"=>"32"}}}, "1"=>{"workout_entry_number"=>"2", "exercise_id"=>"4", "entry_details"=>{"0"=>{"set_number"=>"1", "weight"=>"21", "reps"=>"3"}}}}}

    current_user.workouts.create(params[:workout])

    #@workout = Workout.new
    #@workout.workout_entries.build

    #params[:workout].each do |k,v|
    #  current_user.workouts.create(v)

    #end
    render :json => @workout

=begin
    current_user_workouts = current_user.workouts
    params[:workout].each do |k, v|
      @workout = current_user_workouts.create(v.except("workout_entries"))
      if @workout.save
        v["workout_entries"].each do |k2, v2|
          #creating the workout entries
          @workout_entry = @workout.workout_entries.create(v2.except("entry_details"))
          if @workout_entry.save
            v2["entry_details"].each do |k3, v3|
              #creating the entry details
              @entry_details = @workout_entry.entry_details.create(v3)
              if @entry_details.save
                render :json => @workout
              else
                render :json => {:errors => @entry_details.errors.full_messages}, :status => 422
              end
            end
          else
            render :json => {:errors => @workout_entry.errors.full_messages}, :status => 422
          end
        end
      else
        render :json => {:errors => @workout.errors.full_messages}, :status => 422
      end
    end
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

end



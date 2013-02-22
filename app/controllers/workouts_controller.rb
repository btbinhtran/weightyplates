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

    #p params[:workout]

    #p "workout entries are"
    #p params[:workout][0]
    #hash = JSON.parse(params[:workout])
    #p hash

    #workout_param = params[:workout].except("workout_entry")

    current_user_workouts = current_user.workouts
    params[:workout].each do |k,v|
      #p "the value is "
      #p v["workout_entries"]

      @workout = current_user_workouts.create(v.except("workout_entries"))

      if @workout.save
        v["workout_entries"].each do |k2, v2|
          #p "workout entries now"
          #p v2
          #p v2.except("entry_details")
          @workout_entry = @workout.workout_entries.create(v2.except("entry_details"))
          #p "entry details are"
          #p v2["entry_details"]
          v2["entry_details"].each do |k3, v3|
            p "entry details are"
            p v3
            @workout_entry.entry_details.create(v3)
            p @workout.workout_entries
            p @workout_entry.entry_details
          end
          #@workout_entry.entry_details.create(v2["entry_details"])
          #current_user.workout_entries.create(v.except("entry_details"))
          #puts current_user_workouts.first()
        end

        render :json => @workout


      else
        render :json => { :errors => @workout.errors.full_messages }, :status => 422
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



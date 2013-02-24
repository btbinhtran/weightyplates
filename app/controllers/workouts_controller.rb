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
    model_names = %w(workout workout_entry entry_detail)
    @workout = nil

    def process_name(params, model_names, level, item_on, parent_level, parent_item)
=begin
      p "params"
      p params
      p "model names"
      p model_names
      p "level"
      p level
      p "item_on"
      p item_on
      p "parent level"
      p parent_level
      p "parent item"
      p parent_item
=end
      current_item = model_names[level].pluralize(2)
      nested_item = model_names[level + 1].pluralize(2)

      if (level == 0) && (item_on == 0)
        @workout = current_user.workouts.create((params["0"]).except(nested_item))
        p 'created workout'
        p "item last seen "
        p item_on
        process_name(params, model_names, level + 1, item_on, 0, 0)
      else
        p 'not in workout'
        p current_item
        p params["0"]
        p params["0"][current_item]
        p "item on is"

        #@workout.send(current_item.to_sym).create(params["0"][current_item]["#{item_on}"])
        current_entry = (params["0"][current_item]["#{item_on}"]).except(nested_item)
        p current_entry
        @workout.send(current_item.to_sym).create(current_entry)


        #p @workout.send(current_item.to_sym)
        #p params["0"][current_item]["#{item_on}"]
        #p item_on
      end


      #p "showing params"
      #p params
      #last_key = params.keys.last
      #p "last key"
=begin
      p "position is"
      p position

      #p last_key
      #current_item = models[position].pluralize(2)
      #nested_item = models[position + 1].pluralize(2)

      #p "params are"
      #p (params["0"])

      if position == 0
        @workout = current_user.workouts.create((params["0"]).except(nested_item))
        p @workout
        p "workout creation started"
        #puts params["0"]
        #puts params["0"][nested_item]
        process_name(params["0"][nested_item], 1, models)
      end

      if position != 0
        puts "after created workout"
        puts params["0"]

        params.each do |k, v|
          p "iterating"
          #p current_item
          #p hash_ref
          p v
          @workout.send(current_item.to_sym).create(v.except(nested_item))
          #p @workout.current_item.create(v.except(nested_item))
          #p v["workout_entries"].size
          #p @workout.workout_entries
          #p "nested item"
          #p v[nested_item]



          #size_of_nested = v[nested_item].size
          #process_name(v[nested_item], 1, models)
          #current_user.workouts.create(v.except("workout_entries"))
        end

      end
=end

    end

    #p models[1].pluralize(2)
    #params, models, level, item_on, parent_level, parent_item
    process_name(params[:workout], model_names, 0, 0, "n/a", "n/a")
    render :json => {:errors => @workout.errors.full_messages}, :status => 422
=begin
    #creating the workout
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



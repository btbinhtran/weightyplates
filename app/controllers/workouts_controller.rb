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

    def process_name(params, model_names, level, item_on, parent_level, parent_item, workout, item_transversed, with_nested)

      current_item = model_names[level].pluralize(2)
      if model_names[level + 1]
        nested_item = model_names[level + 1].pluralize(2)
      end

      if (level == 0) && (item_on == 0) && (@workout == nil)
        @workout = current_user.workouts.create((params["0"]).except(nested_item))
        p 'created workout'
        p model_names[level + 1]
        parent_level = 0
        parent_item = 0
        process_name(params, model_names, level + 1, item_on, parent_level, parent_item, @workout, item_transversed.push(0), with_nested)
      else
        p 'not in workout'

        #intermediate levels of nesting
        if model_names[level + 1]
          #p "inter start"
          #p current_item
          #p params["0"][current_item]
          with_nested = params["0"][current_item]["#{item_on}"]
          #p 'stringify'

          current_entry = with_nested.except(nested_item)
          #p current_entry
          @workout_entry = @workout.send(current_item.to_sym).create(current_entry)
          #p @workout
          workout = @workout_entry

          p "nested item"


          process_name(params, model_names, (level + 1), item_on, (parent_level + 1), 0,  workout, item_transversed.push(item_on),with_nested )

        else
          #most inner level of nesting
          if !model_names[level + 1]
            p 'most inner level'
            p current_item
            p  workout
            p "item transverse level"
            p item_transversed
            p with_nested
            if with_nested[current_item].size == 1
              p "one inner most "
              workout.send(current_item.to_sym).create(with_nested[current_item]["0"])
            else
              with_nested[current_item].each do |k,v|
                workout.send(current_item.to_sym).create(v)
              end


            end

            #still need to handle the case where there are no entry details

            #@workout.send(current_item.to_sym).create(current_entry)
            #p params["0"][current_item]
            #p params["0"][current_item].size
            #p item_on
            #p (params["0"][current_item]["#{item_on}"])
          end
        end




      end

    end

    #p models[1].pluralize(2)
    #params, models, level, item_on, parent_level, parent_item
    process_name(params[:workout], model_names, 0, 0, "n/a", "n/a", @workout, %w(), "n/a")
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



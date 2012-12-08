class WorkoutsController < ApplicationController
  respond_to :json

  def index
    respond_with(Workout.all)
  end
end

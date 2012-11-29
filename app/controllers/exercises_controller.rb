class ExercisesController < ApplicationController
  respond_to :json

  def index
    respond_with Exercise.all
  end
end

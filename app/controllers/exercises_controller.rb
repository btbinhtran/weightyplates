class ExercisesController < ApplicationController
  doorkeeper_for :all

  respond_to :json

  def index
    respond_with Exercise.all
  end
end

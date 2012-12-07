class ExercisesController < ApplicationController
  # doorkeeper_for :all

  respond_to :json

  def index(conditions = {})
    conditions[:type] = params[:type] if params[:type]
    conditions[:muscle] = params[:muscle] if params[:muscle]
    conditions[:equipment] = params[:type] if params[:equipment]
    conditions[:mechanics] = params[:mechanics] if params[:mechanics]
    conditions[:force] = params[:force] if params[:force]
    conditions[:is_sport] = params[:is_sport] if params[:is_sport]
    conditions[:level] = params[:level] if params[:level]

    respond_with Exercise.all(conditions: conditions)
  end
end

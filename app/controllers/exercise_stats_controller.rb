class ExerciseStatsController < ApplicationController
  # doorkeeper_for :all
  respond_to :json
  before_filter :authenticate_user!

  def index
    respond_with current_user.exercise_stats
  end
end

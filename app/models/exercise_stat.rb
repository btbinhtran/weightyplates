class ExerciseStat < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise

  attr_accessible :best_reps, :best_weight, :exercise_id, :user_id

  validates :user_id, presence: true
  validates :exercise_id, presence: true
end

class ExerciseStat < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :exercise

  attr_accessible :best_reps, :best_weight, :exercise_id, :user_id

  validates :user_id, presence: true
  validates :exercise_id, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 790}
end

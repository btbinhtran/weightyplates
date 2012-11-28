class WorkoutEntry < ActiveRecord::Base
  attr_accessible :workout_id, :exercise_id

  belongs_to :workout
  belongs_to :exercise
  has_many :entry_details

  validates :exercise_id, presence: true
  validates :workout_id, presence: true
end

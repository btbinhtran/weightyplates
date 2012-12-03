class WorkoutEntry < ActiveRecord::Base
  belongs_to :workout
  belongs_to :exercise
  has_many :entry_details, dependent: :destroy

  attr_accessible :workout_id, :exercise_id

  validates :exercise_id, presence: true
  validates :workout_id, presence: true
end

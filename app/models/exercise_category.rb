class ExerciseCategory < ActiveRecord::Base
  attr_accessible :category_id, :exercise_id
  belongs_to :exercise
  belongs_to :category

  validates :exercise_id, presence: true
  validates :category_id, presence: true
end

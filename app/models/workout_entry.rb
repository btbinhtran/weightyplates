class WorkoutEntry < ActiveRecord::Base

  belongs_to :workout
  belongs_to :exercise
  has_many :entry_details, dependent: :destroy, :inverse_of => :workout_entry

  attr_accessible :workout_id, :workout_entry_number,:exercise_id, :entry_details

  validates :exercise_id, presence: true, numericality: {only_integer: true}, :inclusion => { :in => 1..790 }
  validates :workout_id, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validates :workout_entry_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}

  validates_associated :entry_details

end

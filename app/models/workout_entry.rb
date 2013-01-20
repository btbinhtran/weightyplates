class WorkoutEntry < ActiveRecord::Base
  belongs_to :workout
  belongs_to :exercise
  has_many :entry_details, dependent: :destroy

  attr_accessible :workout_id, :exercise_id, :workout_entry_number

  validates :exercise_id, presence: true, numericality: {only_integer: true}, :inclusion => { :in => 1..790 }
  validates :workout_id, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validates :workout_entry_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}

=begin
  after_create :something

  private
    def something
      puts "something"
    end
=end

end

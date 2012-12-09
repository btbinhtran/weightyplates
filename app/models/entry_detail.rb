class EntryDetail < ActiveRecord::Base
  belongs_to :workout_entry
  attr_accessible :workout_entry_id, :reps, :set_number, :weight

  validates_presence_of :reps
  validates_presence_of :set_number
  validates_presence_of :weight

end

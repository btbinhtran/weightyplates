class EntryDetail < ActiveRecord::Base

  belongs_to :workout_entry
  attr_accessible :workout_entry_id, :reps, :set_number, :weight

  validates_presence_of :reps, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validates_presence_of :set_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1}
  validates_presence_of :weight, presence: true, numericality: {only_decimal: true, greater_than: 0}

end

class EntryDetail < ActiveRecord::Base
  attr_accessible :reps, :set_number, :weight

  validates_presence_of :reps
  validates_presence_of :set_number
  validates_presence_of :weight

end

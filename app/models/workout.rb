class Workout < ActiveRecord::Base
  belongs_to :user
  has_many :workout_entries

  attr_accessible :id, :name, :note, :unit

  validates_presence_of :name, :unit
end

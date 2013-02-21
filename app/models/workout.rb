class Workout < ActiveRecord::Base

  has_many :workout_entries
  attr_accessible :id, :name, :note, :unit,  :workout_entries_attributes
  belongs_to :user
  accepts_nested_attributes_for :workout_entries

  validates_presence_of :name, :with => /\A\Z/
  validates_presence_of :unit, :inclusion => %w(kg lb)
  validates_associated :workout_entries

  default_scope order("created_at DESC")

end

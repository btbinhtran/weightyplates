class Workout < ActiveRecord::Base

  has_many :workout_entries, dependent: :destroy, :inverse_of => :workout
  attr_accessible :id, :name, :note, :unit, :workout_entries
  belongs_to :user

  validates_presence_of :name #, :with => /\A\Z/
  validates_inclusion_of :unit, :in => %w(kg lb)
  validates_associated :workout_entries

  default_scope order("created_at DESC")

end

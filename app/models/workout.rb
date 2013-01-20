class Workout < ActiveRecord::Base
  belongs_to :user
  has_many :workout_entries, dependent: :destroy

  attr_accessible :id, :name, :note, :unit
  default_scope order("created_at DESC")

  validates_presence_of :name, :with => /\A\Z/
  validates_presence_of :unit, :inclusion => %w(kg lb)
  #validates_format_of :note, :with => /\A\Z/
end

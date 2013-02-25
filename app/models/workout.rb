class Workout < ActiveRecord::Base

  has_many :workout_entries, dependent: :destroy, :inverse_of => :workout
  attr_accessible :id, :name, :note, :unit, :workout_entries_attributes, :workout_entries
  belongs_to :user


  accepts_nested_attributes_for :workout_entries,  :allow_destroy => true
  accepts_nested_attributes_for :user

  validates_presence_of :name #, :with => /\A\Z/
  validates :unit, :presence => true, :inclusion => {:in => %w(kg lb)}
  validates_associated :workout_entries

  default_scope order("created_at DESC")

end

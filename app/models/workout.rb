class Workout < ActiveRecord::Base


  after_save :checkout_workout_entries
  before_validation :things_to_do_after

  belongs_to :user
  has_many :workout_entries, dependent: :destroy, :inverse_of => :workout
  accepts_nested_attributes_for :workout_entries

  attr_accessible :id, :name, :note, :unit
  default_scope order("created_at DESC")

  validates_presence_of :name, :with => /\A\Z/
  validates_presence_of :unit, :inclusion => %w(kg lb)
  validates_associated :workout_entries

  def checkout_workout_entries
    puts "checking out workout entries"
  end

  def things_to_do_after
    puts 'after validating'
  end

end

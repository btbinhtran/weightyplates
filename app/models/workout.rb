class Workout < ActiveRecord::Base

  belongs_to :user
  has_many :workout_entries, dependent: :destroy, :inverse_of => :workout

  attr_accessible :id, :name, :note, :unit,:workout_entries

  validates_presence_of :name #, :with => /\A\Z/
  validates :unit, :presence => true, :inclusion => {:in => %w(kg lb)}

  validates_associated :workout_entries

  default_scope order("created_at DESC")

end

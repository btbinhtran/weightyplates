class Workout < ActiveRecord::Base
  attr_accessible :id, :name, :note, :unit
  validates_presence_of :name, :unit
end

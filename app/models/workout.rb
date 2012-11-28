class Workout < ActiveRecord::Base
  attr_accessible :id, :name, :note, :unit
end

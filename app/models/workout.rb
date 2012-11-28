class Workout < ActiveRecord::Base
  belongs_to :user

  attr_accessible :id, :name, :note, :unit

  validates_presence_of :name, :unit
end

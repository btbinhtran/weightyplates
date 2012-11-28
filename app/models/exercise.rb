class Exercise < ActiveRecord::Base
  attr_accessible :name
  has_many :exercise_categories

  validates :name, presence: true
end

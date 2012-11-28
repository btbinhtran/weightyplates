class Category < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :exercise_categories

  validates_presence_of :name
  validates :type, presence: true,
            inclusion: { in: %w(resistance bodypart), message: "%{value} is not a valid type" }
end

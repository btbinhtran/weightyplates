class Category < ActiveRecord::Base
  # attr_accessible :title, :body
  validates :type, presence: true,
            inclusion: { in: %w(resistance bodypart), message: "%{value} is not a valid type" }
end

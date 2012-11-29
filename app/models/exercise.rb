class Exercise < ActiveRecord::Base
  attr_accessible :name
  has_many :exercise_categories
  has_many :categories, through: :exercise_categories

  validates :name, presence: true

  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]
    super(options)
  end
end

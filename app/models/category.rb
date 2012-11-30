class Category < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :exercise_categories
  has_many :exercises, through: :exercise_categories

  validates_presence_of :name
  validates :kind, presence: true,
            inclusion: { in: %w(resistance bodypart), message: "%{value} is not a valid type" }

  def to_json(options = {})
    options[:except] ||= [:id, :created_at, :updated_at]
    super(options)
  end
end

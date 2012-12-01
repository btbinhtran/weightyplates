class Exercise < ActiveRecord::Base
  self.inheritance_column = nil

  attr_accessible :name, :muscle, :equipment, :mechanics, :force, :is_sport, :level

  validates :name, presence: true, uniqueness: true
  validates :type, presence: true, uniqueness: true, inclusion: {in: ['Cardio', 'Olypic Weightlifting', 'Plyometrics',
                                                                      'Powerlifting', 'Strength', 'Stretching', 'Strongman']}
  validates :muscle, presence: true, inclusion: {in: ['Abdominals', 'Abductors',
                                                      'Biceps', 'Calves', 'Chest', 'Forearms', 'Glutes', 'Hamstrings',
                                                      'Lats', 'Lower Back', 'Middle Back', 'Neck', 'Quadriceps',
                                                      'Shoulders', 'Traps', 'Triceps']}
  validates :equipment, presence: true, inclusion: {in: ['Bands', 'Barbell', 'Body Only', 'Cable', 'Dumbbell', 'E-Z Curl Bar',
                                                         'Exercise Ball', 'Foam Roll', 'Kettlebells',
                                                         'Machine', 'Medicine Ball', 'None', 'Other']}
  validates :mechanics, presence: true
  validates :force, presence: true
  validates :is_sport, inclusion: {in: [true, false]}
  validates :level, presence: true

  def to_json(options = {})
    options[:except] ||= [:created_at, :updated_at]

    super(options)
  end

end

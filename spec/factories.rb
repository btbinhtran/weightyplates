FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "bob#{i}@bob.com" }
    password "testtest"
    password_confirmation "testtest"
    default_unit "lb"
  end

  factory :workout do
    name "workout name"
    note "a note"
    unit "kilograms"
  end

  factory :entry_detail do
    set_number  1
    reps        1
    weight      150.5
  end

  factory :exercise do
    sequence(:name) { |i| "Exercise #{i}" }
    type 'Strength'
    muscle 'Chest'
    equipment 'Machine'
    mechanics 'Compound'
    force 'N/A'
    level 'Intermediate'
  end

  factory :exercise_stat do
    association :user
    association :exercise
    best_reps 10
    best_weight 50
  end

  factory :workout_entry do
    association :workout
    association :exercise
    workout_entry_number 1
  end
end
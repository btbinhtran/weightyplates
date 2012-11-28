FactoryGirl.define do
  factory :user do
    email    "bob@bob.com"
    password "testtest"
    password_confirmation "testtest"
    default_unit "lb"
  end

  factory :category do
    type "resistance"
    sequence(:name) { |i| "Cat #{i}" }
  end

  factory :exercise do
    sequence(:name) { |i| "Exercise #{i}" }
  end

  factory :exercise_category do
    association :exercise
  end
end
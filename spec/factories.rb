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

end
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
end
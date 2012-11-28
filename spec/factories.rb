FactoryGirl.define do
  factory :user do
    email    "bob@bob.com"
    password "testtest"
    password_confirmation "testtest"
    default_unit "lb"
  end
end
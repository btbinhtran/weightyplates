FactoryGirl.define do
  factory :user do
    name     "Bob Momo"
    email    "bob@bob.com"
    password "testtest"
    password_confirmation "testtest"
  end
end
require "spec_helper"
require "capybara/rails"

def sign_in
  user = FactoryGirl.create(:user)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: 'testtest'
  click_button "Sign in"
  user
end

def sign_out
  click_link_or_button('Logout')
end

def last_json
  page.source
end
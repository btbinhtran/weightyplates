require 'spec_helper'

describe "Dashboard" do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "get dashboard" do

    it "should redirect to dashboard upon proper sign up" do
      visit new_user_registration_path
      fill_in 'user_email', with: 'bob@bob.com'
      fill_in 'user_password', with: 'testtest'
      fill_in 'user_password_confirmation', with: 'testtest'
      click_button "Sign up"
      current_path.should == dashboard_index_path
    end


    it "should redirect to dashboard upon proper sign in" do
      visit new_user_session_path
      fill_in "Email", with: "bob@bob.com"
      fill_in "Password", with: "testtest"
      click_button "Sign in"
      current_path.should == dashboard_index_path
    end



  end

end

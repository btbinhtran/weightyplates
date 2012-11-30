require 'test_integration_helper'

describe "User authentication" do
  before do
    @user = FactoryGirl.create(:user)
  end

  it "should redirect to dashboard upon proper sign up" do
    visit new_user_registration_path
    new_user = FactoryGirl.build(:user)
    fill_in 'user_email', with: new_user.email
    fill_in 'user_password', with: 'testtest'
    fill_in 'user_password_confirmation', with: 'testtest'
    click_button "Sign up"
    current_path.should == dashboard_index_path
  end

  it "should redirect to dashboard upon proper sign in" do
    sign_in
    current_path.should == dashboard_index_path
  end

  describe "reset password" do
    it "should redirect to sign in page" do
      visit new_user_password_path
      fill_in 'user_email', with: @user.email
      click_button 'Send me reset password instructions'
      current_path.should == new_user_session_path
    end
  end

  describe "logout" do
    it "should redirect to root path '/'" do
      sign_in
      sign_out
      current_path.should == root_path
    end
  end
end

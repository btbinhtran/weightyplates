require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  it "should not be valid without an email" do
    @user.email = nil
    @user.should_not be_valid
  end

  it "should not be valid without password" do
    @user.password = nil
    @user.should_not be_valid
  end
end
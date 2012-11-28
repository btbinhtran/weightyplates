require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  subject { @user }

  #it { should respond_to(:exercises) }
  #it { should respond_to(:workouts) }

  it "should not be valid without a default_unit" do
    @user.default_unit = nil
    @user.save
    @user.should_not be_valid
  end

  describe "default_unit" do
    it "should be valid if it is 'lb'" do
      @user.default_unit = 'lb'
      @user.save
      @user.should be_valid
    end

    it "should be valid if it is 'kg'" do
      @user.default_unit = 'kg'
      @user.save
      @user.should be_valid
    end

    it "should be invalid if not 'lb' or 'kg'" do
      @user.default_unit = 'hack'
      @user.save
      @user.should_not be_valid
    end
  end

  it "should not be valid without an email" do
    @user.email = nil
    @user.should_not be_valid
  end

  describe "when email address is already taken" do
    it "should not be valid" do
      @user.save
      user_with_same_email = @user.dup
      user_with_same_email.save
      user_with_same_email.should_not be_valid
    end
  end

  it "should not be valid without password" do
    @user.password = nil
    @user.save
    @user.should_not be_valid
  end
end
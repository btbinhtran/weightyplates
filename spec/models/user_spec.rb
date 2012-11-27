require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end
  
  it { should respond_to(:username) }
  it { should respond_to(:email) }
  
  context "when username is not present" do
    before { @user.username = nil }
    it { should_not be_valid }
  end
end

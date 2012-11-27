require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  it { should respond_to(:email) }

end

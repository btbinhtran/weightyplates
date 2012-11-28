require 'spec_helper'

describe Exercise do
  before do
    @exercise = FactoryGirl.build(:exercise)
  end
  subject { @exercise }

  it { should respond_to(:categories) }

  it "should not be valid without name" do
    @exercise.name = nil
    @exercise.save
    @exercise.should_not be_valid
  end
end

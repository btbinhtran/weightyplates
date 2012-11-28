require 'spec_helper'

describe ExerciseStat do
  before do
    @ex_stat = FactoryGirl.build(:exercise_stat)
  end
  subject { @ex_stat }

  it { should respond_to(:user) }

  it "should be invalid without user_id" do
    @ex_stat.user_id = nil
    @ex_stat.save
    @ex_stat.should_not be_valid
  end

  it "should be invalid without exercise_id" do
    @ex_stat.exercise_id = nil
    @ex_stat.save
    @ex_stat.should_not be_valid
  end
end

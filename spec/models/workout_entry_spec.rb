require 'spec_helper'

describe WorkoutEntry do
  before do
    @work_entry = FactoryGirl.build(:workout_entry)
  end
  subject { @work_entry }

  it { should respond_to(:entry_details) }

  it "should be invalid without exercise_id" do
    @work_entry.exercise_id = nil
    @work_entry.save
    @work_entry.should_not be_valid
  end

  it "should be invalid without workout_id" do
    @work_entry.workout_id = nil
    @work_entry.save
    @work_entry.should_not be_valid
  end
end

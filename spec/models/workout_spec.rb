require 'spec_helper'

describe Workout do
  before do
    @workout = FactoryGirl.build(:workout)
  end

  subject { @workout }

  it { should respond_to(:user) }

  describe "workout entry association" do
    before do
      @workout.save
    end
    let!(:older_workout_entry) do
      FactoryGirl.create(:workout_entry, workout: @workout, created_at: 1.day.ago)
    end
    let!(:newer_workout_entry) do
      FactoryGirl.create(:workout_entry, workout: @workout, created_at: 1.hour.ago)
    end

    it { should respond_to(:workout_entries) }

    it "should destroy associated workout entries" do
      workout_entries = @workout.workout_entries.dup
      @workout.destroy
      workout_entries.should_not be_empty
      workout_entries.each do |workout_entry|
        WorkoutEntry.find_by_id(workout_entry.id).should be_nil
      end
    end
  end


  it "should not be valid without a name" do
    @workout.name = nil
    @workout.save
    @workout.should_not be_valid
  end

  it "should not be valid without a unit" do
    @workout.unit = nil
    @workout.save
    @workout.should_not be_valid
  end

  it "should be valid without a note" do
    @workout.note = nil
    @workout.save
    @workout.should be_valid
  end



end

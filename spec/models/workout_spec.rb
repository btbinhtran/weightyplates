require 'spec_helper'

describe Workout do
  before do
    @workout = FactoryGirl.build(:workout)
  end

  subject { @workout }

  it { should respond_to(:user) }

  it { should ensure_inclusion_of(:unit).in_array( %w(kg lb)) }

  it { should_not allow_value(nil).for(:name) }
  it { should_not allow_value(nil).for(:unit) }
  it { should allow_value(nil).for(:note) }

  it "should have created_at order default scope" do
    workouts = []
    3.times do |num|
      workouts << FactoryGirl.create(:workout, created_at: num.hours.ago)
    end

    Workout.all.each_with_index do |workout, i|
      workout.should == workouts[i]
    end
  end

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

    it "should not have associated workout entries when workout is destroyed" do
      workout_entries = @workout.workout_entries
      @workout.destroy
      workout_entries.should be_empty
      workout_entries.each do |workout_entry|
        WorkoutEntry.find_by_id(workout_entry.id).should be_nil
      end
    end
  end





end

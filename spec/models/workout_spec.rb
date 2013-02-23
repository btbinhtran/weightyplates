require 'spec_helper'

describe Workout do
  before do
    @workout = FactoryGirl.build(:workout)
  end

  subject { @workout }

  it { should respond_to(:user) }

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

  it "should not save if the unit is not in kg or lb" do
    @workout.unit = "232r"
    #@workout = Workout.new(:unit => 'blah blah', :name => 'Just a name', :note => 'A note')

    #@workout = FactoryGirl.build(:workout, :unit => "sagfsd")
    @workout.should_not be_valid



    #@workout_save = @workout.save
    #p "workout save"
    #p @workout
    #@workout.should_not be_valid
  end

  it "should be valid without a note" do
    @workout.note = nil
    @workout.save
    @workout.should be_valid
  end



end

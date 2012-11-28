require 'spec_helper'

describe Workout do
  before do
    @workout = FactoryGirl.build(:workout)
  end

  subject { @workout }

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

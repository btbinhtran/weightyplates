require 'spec_helper'

describe ExerciseCategory do
  before do
    @ex_cat = FactoryGirl.build(:exercise_category)
  end
  subject { @ex_cat }

  it { should respond_to(:exercise) }
  it { should respond_to(:category) }

  it "should not be valid without exercise_id" do
    @ex_cat.exercise_id = nil
    @ex_cat.save
    @ex_cat.should_not be_valid
  end

  it "should not be valid without category_id" do
    @ex_cat.category_id = nil
    @ex_cat.save
    @ex_cat.should_not be_valid
  end
end

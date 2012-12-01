require 'spec_helper'

describe Exercise do
  before do
    @exercise = FactoryGirl.build(:exercise)
  end
  subject { @exercise }

  it "should not be valid without name" do
    @exercise.name = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  it "should not be valid if name exists" do
    new_exercise = @exercise.dup
    @exercise.save
    new_exercise.save
    new_exercise.should_not be_valid
  end

  it "should not be valid without type" do
    @exercise.type = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  describe "type" do
    ['Cardio', 'Olypic Weightlifting', 'Plyometrics',
     'Powerlifting', 'Strength', 'Stretching', 'Strongman'].each do |type|
      it "should validate inclusion of #{type}" do
        @exercise.type = type
        @exercise.save
        @exercise.errors[:type].should be_blank
      end
    end

    it "should be invalid with anything outside of type" do
      @exercise.type = "blah"
      @exercise.save
      @exercise.errors[:type].should_not be_blank
    end
  end

  it "should not be valid without muscle" do
    @exercise.muscle = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  describe "muscle" do
    ['Abdominals', 'Abductors',
     'Biceps', 'Calves', 'Chest', 'Forearms', 'Glutes', 'Hamstrings',
     'Lats', 'Lower Back', 'Middle Back', 'Neck', 'Quadriceps',
     'Shoulders', 'Traps', 'Triceps'].each do |muscle|
      it "should validate inclusion of #{muscle}" do
        @exercise.muscle = muscle
        @exercise.save
        @exercise.errors[:muscle].should be_blank
      end
    end

    it "should be invalid with anything outside of muscle group" do
      @exercise.muscle = "blah"
      @exercise.save
      @exercise.errors[:muscle].should_not be_blank
    end
  end

  it "should not be valid without equipment" do
    @exercise.equipment = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  describe "equipment" do
    ['Bands', 'Barbell', 'Body Only', 'Cable', 'Dumbbell', 'E-Z Curl Bar',
     'Exercise Ball', 'Foam Roll', 'Kettlebells',
     'Machine', 'Medicine Ball', 'None', 'Other'].each do |equipment|
      it "should validate inclusion of #{equipment}" do
        @exercise.equipment = equipment
        @exercise.save
        @exercise.errors[:equipment].should be_blank
      end
    end

    it "should be invalid with anything outside of equipment group" do
      @exercise.equipment = "blah"
      @exercise.save
      @exercise.errors[:equipment].should_not be_blank
    end
  end

  it "should not be valid without mechanics" do
    @exercise.mechanics = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  it "should not be valid without force" do
    @exercise.force = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  it "should not be valid without is_sport" do
    @exercise.is_sport = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  it "should not be valid without level" do
    @exercise.level = nil
    @exercise.save
    @exercise.should_not be_valid
  end

  describe "#to_json" do
    before do
      @exercise.save!
    end

    it "should include name" do
      @exercise.to_json.should have_json_path("name")
    end

    it "should exclude created_at" do
      @exercise.to_json.should_not have_json_path("created_at")
    end

    it "should exclude updated_at" do
      @exercise.to_json.should_not have_json_path("updated_at")
    end
  end
end

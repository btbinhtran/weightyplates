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

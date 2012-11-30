require 'spec_helper'

describe Category do
  before do
    @category = FactoryGirl.build(:category)
  end

  subject { @category }

  it { should respond_to(:exercises) }

  it "should not be valid without a name" do
    @category.name = nil
    @category.save
    @category.should_not be_valid
  end

  it "should not be valid without a kind" do
    @category.kind = nil
    @category.save
    @category.should_not be_valid
  end

  describe "kind" do
    it "should be valid if it is 'resistance'" do
      @category.kind = 'resistance'
      @category.save
      @category.should be_valid
    end

    it "should be valid if it is 'bodypart'" do
      @category.kind = 'bodypart'
      @category.save
      @category.should be_valid
    end

    it "should not be valid if it is not 'resistance' or 'bodypart'" do
      @category.kind = 'hack'
      @category.save
      @category.should_not be_valid
    end
  end

  describe "#to_json" do
    before do
      @category.save!
    end

    it "should include kind" do
      @category.to_json.should have_json_path('kind')
    end

    it "should exclude id" do
      @category.to_json.should_not have_json_path('id')
    end

    it "should exclude created_at" do
      @category.to_json.should_not have_json_path('created_at')
    end

    it "should exclude updated_at" do
      @category.to_json.should_not have_json_path('updated_at')
    end
  end
end

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

  it "should not be valid without a type" do
    @category.type = nil
    @category.save
    @category.should_not be_valid
  end

  describe "type" do
    it "should be valid if it is 'resistance'" do
      @category.type = 'resistance'
      @category.save
      @category.should be_valid
    end

    it "should be valid if it is 'bodypart'" do
      @category.type = 'bodypart'
      @category.save
      @category.should be_valid
    end

    it "should not be valid if it is not 'resistance' or 'bodypart'" do
      @category.type = 'hack'
      @category.save
      @category.should_not be_valid
    end
  end
end

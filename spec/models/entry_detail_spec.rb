require 'spec_helper'

describe EntryDetail do
  before do
    @entry_detail = FactoryGirl.build(:entry_detail)
  end

  subject { @entry_detail}


  it { should respond_to(:workout_entry) }

  it "should not be valid without a set" do
    @entry_detail.set_number = nil
    @entry_detail.save
    @entry_detail.should_not be_valid
  end

  it "should not be valid without a rep" do
    @entry_detail.reps = nil
    @entry_detail.save
    @entry_detail.should_not be_valid
  end

  it "should not be valid without a weight" do
    @entry_detail.weight = nil
    @entry_detail.save
    @entry_detail.should_not be_valid
  end

end

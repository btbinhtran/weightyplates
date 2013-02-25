require 'spec_helper'

describe WorkoutEntry do
  before do
    @work_entry = FactoryGirl.build(:workout_entry)
  end
  subject { @work_entry }

  it { should_not allow_value(nil).for(:exercise_id)}
  it { should_not allow_value(nil).for(:workout_id)}

  it { should validate_numericality_of(:exercise_id)}
  it { should validate_numericality_of(:workout_id)}

  describe "entry detail association" do
    before do
      @work_entry.save
    end
    let!(:older_entry_detail) do
      FactoryGirl.create(:entry_detail, workout_entry: @work_entry, created_at: 1.day.ago)
    end
    let!(:newer_workout_entry) do
      FactoryGirl.create(:entry_detail, workout_entry: @work_entry, created_at: 1.hour.ago)
    end
    it "should destroy associated entry details" do
      entry_details = @work_entry.entry_details
      @work_entry.destroy
      entry_details.should be_empty
      entry_details.each do |detail|
        EntryDetail.find_by_id(detail.id).should be_nil
      end
    end
  end

  it { should respond_to(:entry_details) }

end

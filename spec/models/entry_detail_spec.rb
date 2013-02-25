require 'spec_helper'

describe EntryDetail do
  before do
    @entry_detail = FactoryGirl.build(:entry_detail)
  end

  subject { @entry_detail}

  it { should respond_to(:workout_entry) }

  it { should_not allow_value(nil).for(:set_number) }
  it { should_not allow_value(nil).for(:reps) }
  it { should_not allow_value(nil).for(:weight) }

end

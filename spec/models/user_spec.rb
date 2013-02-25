require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build(:user)
  end

  subject { @user }

  describe "workout association" do
    before do
      @user.save
    end
    let!(:older_workout) do
      FactoryGirl.create(:workout, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_workout) do
      FactoryGirl.create(:workout, user: @user, created_at: 1.hour.ago)
    end

    it { should respond_to(:workouts) }

    it "should destroy associated workouts" do
      workouts = @user.workouts.dup
      @user.destroy
      workouts.should_not be_empty
      workouts.each do |workout|
        Workout.find_by_id(workout.id).should be_nil
      end
    end
  end

  describe "exercise stat association" do
    before do
      @user.save
    end
    let!(:older_exercise_stat) do
      FactoryGirl.create(:exercise_stat, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_exercise_stat) do
      FactoryGirl.create(:exercise_stat, user: @user, created_at: 1.hour.ago)
    end

    it { should respond_to(:exercise_stats) }

    it "should destroy associated exercise stats" do
      exercise_stats = @user.exercise_stats.dup
      @user.destroy
      exercise_stats.should_not be_empty
      exercise_stats.each do |exercise_stat|
        ExerciseStat.find_by_id(exercise_stat.id).should be_nil
      end
    end
  end

  it { should_not allow_value(nil).for(:default_unit) }

  describe "default_unit" do
    it { should ensure_inclusion_of(:default_unit).in_array( %w(kg lb)) }

  end

  it { should_not allow_value(nil).for(:email)}

  describe "when email address is already taken" do
    it "should not be valid" do
      @user.save
      user_with_same_email = @user.dup
      user_with_same_email.save
      user_with_same_email.should_not be_valid
    end
  end

  it { should_not allow_value(nil).for(:password)}
end
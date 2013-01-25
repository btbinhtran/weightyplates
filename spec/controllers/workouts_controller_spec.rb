require 'spec_helper'

describe WorkoutsController do
  include Devise::TestHelpers
  let!(:application) { Doorkeeper::Application.create!(name: "BobApp", redirect_uri: "http://app.com") }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: user.id) }
  before do
    sign_in user
  end

  describe "index" do
    before do
      @workouts = []
      3.times do |num|
        @workouts << FactoryGirl.create(:workout, user_id: user.id, created_at: num.hours.ago)
      end
    end

    it "should list recent workouts" do
      get :index, format: :json
      @response.body.should have_json_size(3)
      user.workouts.each_with_index do |workout, i|
        workout.should == @workouts[i]
      end
    end
  end

  describe "create workout" do
    it "should not throw errors with defaulted units and name with additional valid details" do
      wo = {:unit=> "kg", :name =>"blah time", :workout_entry =>[{:workout_entry_number =>"1", :exercise_id =>2, "entry_detail"=>[{:set_number =>"1", :weight =>"53", :reps =>"45"}, {:set_number =>"2", :weight =>nil, :reps =>nil}]}]}
      post(:create, workout: wo, format: :json)
      @response.body.should_not have_json_path("errors")
    end

    it "should add a workout" do
      wo = {:unit=> "kg", :name =>"blah time", :workout_entry =>[{:workout_entry_number =>"1", :exercise_id =>2, "entry_detail"=>[{:set_number =>"1", :weight =>"53", :reps =>"45"}, {:set_number =>"2", :weight =>nil, :reps =>nil}]}]}
      expect do
        post(:create, workout: wo)
      end.to change(user.workouts, :count).by(1)
    end
  end

  describe "update workout" do

    it "should update a workout" do
      wo = FactoryGirl.create(:workout, user_id: user.id)
      put(:update, id: wo.id, workout: {name: "Blimy"})
      json = ActiveSupport::JSON.decode(@response.body)
      json['name'].should == "Blimy"
    end
  end

  it "should be able to delete workout" do
    workout = FactoryGirl.create(:workout, user_id: user.id)
    expect do
      delete :destroy, format: :json, id: workout.id
    end.to change(user.workouts, :count).by(-1)
  end
end

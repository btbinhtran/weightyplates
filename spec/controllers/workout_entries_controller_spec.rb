require 'spec_helper'

describe WorkoutEntriesController do
  include Devise::TestHelpers
  let!(:application) { Doorkeeper::Application.create!(name: "BobApp", redirect_uri: "http://app.com") }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: user.id) }
  let!(:workout) { FactoryGirl.create(:workout, user_id: user.id) }
  let!(:exercise) { FactoryGirl.create(:exercise) }
  before do
    sign_in user
  end

  describe "create workout" do
    it "should throw errors if there are missing attributes" do
      post :create, format: :json, workout_id: workout.id
      json = ActiveSupport::JSON.decode(@response.body)
      @response.body.should have_json_path("errors")
    end

    it "should add a workout entry" do
      wo_entry = { :exercise_id => exercise.id }
      expect do
        post(:create, workout_entry: wo_entry, workout_id: workout.id)
      end.to change(workout.workout_entries, :count).by(1)
    end
  end

  it "should be able to delete workout entry" do
    wo_entry = FactoryGirl.create(:workout_entry, workout_id: workout.id)
    expect do
      delete :destroy, workout_id: workout.id, id: wo_entry.id
    end.to change(workout.workout_entries, :count).by(-1)
  end
end

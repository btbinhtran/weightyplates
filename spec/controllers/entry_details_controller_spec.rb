require 'spec_helper'

describe EntryDetailsController do
  include Devise::TestHelpers
  let!(:application) { Doorkeeper::Application.create!(name: "BobApp", redirect_uri: "http://app.com") }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: user.id) }
  let!(:workout) { FactoryGirl.create(:workout, user_id: user.id) }
  let!(:exercise) { FactoryGirl.create(:exercise) }
  let!(:workout_entry) { FactoryGirl.create(:workout_entry, workout_id: workout.id, exercise_id: exercise.id) }
  before do
    sign_in user
  end

  describe "create entry details" do
    it "should throw errors if there are missing attributes" do
      post :create, format: :json, workout_id: workout.id, workout_entry_id: workout_entry.id
      @response.body.should have_json_path("errors")
    end

    it "should add an entry detail" do
      attrs = { reps: 10, set_number: 1, weight: 240 }
      expect do
        post(:create, entry_detail: attrs, workout_id: workout.id, workout_entry_id: workout_entry.id)
      end.to change(workout_entry.entry_details, :count).by(1)
    end
  end

    it "should have an associated workout entry" do
      attrs = { reps: 10, set_number: 1, weight: 240 }
      expect do
        post(:create, entry_detail: attrs, workout_id: workout.id, workout_entry_id: workout_entry.id)
      end.to change(workout_entry.entry_details, :count).by(1)
    end


  describe "update entry detail" do
    it "should update an entry detail" do
      entry_detail = FactoryGirl.create(:entry_detail, workout_entry_id: workout_entry.id)
      attrs = {}
      attrs[:weight] = 320
      put(:update, id: entry_detail.id, workout_id: workout.id, workout_entry_id: workout_entry.id, entry_detail: attrs)
      json = ActiveSupport::JSON.decode(@response.body)
      json['weight'].should == "320.0"
    end
  end

  it "should be able to delete entry detail" do
    entry_detail = FactoryGirl.create(:entry_detail, workout_entry_id: workout_entry.id)
    expect do
      delete :destroy, workout_id: workout.id, workout_entry_id: workout_entry.id, id: entry_detail.id
    end.to change(workout_entry.entry_details, :count).by(-1)
  end
end

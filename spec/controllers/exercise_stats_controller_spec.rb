require 'spec_helper'

describe ExercisesController do
  let!(:application) { Doorkeeper::Application.create!(name: "BobApp", redirect_uri: "http://app.com") }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: user.id) }

  describe "index" do
    before do
      2.times do
        FactoryGirl.create(:exercise_stat, user_id: user.id)
      end
    end

    it "should return correct JSON array" do
      # get exercises_path(format: :json, access_token: token.token)
      get :index, format: :json
      @response.body.should have_json_size(2)
    end
  end
end
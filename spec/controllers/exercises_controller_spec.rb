require 'spec_helper'

describe ExercisesController do
  let!(:application) { Doorkeeper::Application.create!(name: "BobApp", redirect_uri: "http://app.com") }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: user.id) }


  describe "index" do
    before do
      2.times do
        FactoryGirl.create(:exercise)
      end
    end

    it "should return correct JSON array" do
      # get exercises_path(format: :json, access_token: token.token)
      get :index, format: :json


      @response.body.should have_json_size(2)
    end

    it "should be able to search by type" do
      FactoryGirl.create(:exercise, name: "A", type: "Cardio")
      get :index, format: :json, type: "Cardio"

      json_array = ActiveSupport::JSON.decode(@response.body)

      json_array.each do |json|
        json['type'].should == "Cardio"
      end
    end

    it "should be able to search by muscle" do
      FactoryGirl.create(:exercise, name: "A", muscle: "Biceps")
      get :index, format: :json, muscle: "Biceps"

      json_array = ActiveSupport::JSON.decode(@response.body)

      json_array.each do |json|
        json['muscle'].should == "Biceps"
      end
    end

    it "should be able to search by equipment" do
      FactoryGirl.create(:exercise, name: "A", equipment: "Foam Roll")
      get :index, format: :json, equipment: "Foam Roll"

      json_array = ActiveSupport::JSON.decode(@response.body)

      json_array.each do |json|
        json['equipment'].should == "Foam Roll"
      end
    end

    it "should be able to search by mechanics" do
      FactoryGirl.create(:exercise, name: "A", mechanics: "Isolation")
      get :index, format: :json, mechanics: "Isolation"

      json_array = ActiveSupport::JSON.decode(@response.body)

      json_array.each do |json|
        json['mechanics'].should == "Isolation"
      end
    end

    it "should be able to search by force" do
      FactoryGirl.create(:exercise, name: "A", force: "Static")
      get :index, format: :json, force: "Static"

      json_array = ActiveSupport::JSON.decode(@response.body)

      json_array.each do |json|
        json['force'].should == "Static"
      end
    end

    it "should be able to search by is_sport" do
      FactoryGirl.create(:exercise, name: "A", is_sport: true)
      get :index, format: :json, is_sport: true

      json_array = ActiveSupport::JSON.decode(@response.body)

      json_array.each do |json|
        json['is_sport'].should == true
      end
    end

    it "should be able to search by level" do
      FactoryGirl.create(:exercise, name: "A", level: "Expert")
      get :index, format: :json, level: "Expert"

      json_array = ActiveSupport::JSON.decode(@response.body)

      json_array.each do |json|
        json['level'].should == "Expert"
      end
    end
  end
end

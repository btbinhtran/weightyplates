require 'test_integration_helper'

describe "Exercises" do
  let!(:application) { Doorkeeper::Application.create!(name: "BobApp", redirect_uri: "http://app.com") }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:token) { Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: user.id) }

  it "index should return correct JSON array" do
    @ex1 = FactoryGirl.create(:exercise)
    @ex2 = FactoryGirl.create(:exercise)
    visit exercises_path(format: :json, access_token: token.token)

    last_json.should have_json_size(2)
  end
end
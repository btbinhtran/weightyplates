require 'test_integration_helper'

describe "Exercises" do

  it "index should return correct JSON array" do
    @ex1 = FactoryGirl.create(:exercise)
    @ex2 = FactoryGirl.create(:exercise)
    visit "/exercises.json"

    last_json.should have_json_size(2)
  end
end
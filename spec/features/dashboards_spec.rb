require 'spec_helper'

describe "Dashboards" do
  before do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "get dashboard" do
    it "should have a success response" do
      visit root_path
      page.should have_content('Fudged me')
    end
  end
  
  
end

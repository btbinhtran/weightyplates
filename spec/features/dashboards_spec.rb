require 'spec_helper'

describe "Dashboards" do
  
  describe "get dashboard" do
    it "should have a success response" do
      visit root_path
      page.should have_content('Fudged me')
    end
  end
  
  
end

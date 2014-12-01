require 'spec_helper'
#
describe "Static pages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home page" do
#    #it "works! (now write some real specs)" do
    it "should have the content 'Sample App'" do
#      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #get static_pages_index_path
      #response.status.should be(200)
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end

  end
  describe "Help page" do
#    #it "works! (now write some real specs)" do
    it "should have the content 'Help'" do
#      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      #get static_pages_index_path
#      #response.status.should be(200)
      visit '/static_pages/help'
      expect(page).to have_content('Help')
      #expect(page).to have_title("awujun")
    end
    it "should have the title 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_title("#{base_title} | Help")
    end
 end

  describe "About page" do

    it "should have the content 'About Us'" do 
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end
    it "should have the title 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_title("#{base_title} | About Us")
    end
  end

  describe "Contract" do

    it "should have the content 'Contract'" do 
      visit '/static_pages/contract'
      expect(page).to have_content('Contract')
    end
    it "should have the title 'Contract'" do
      visit '/static_pages/contract'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contract")
    end
 end
end

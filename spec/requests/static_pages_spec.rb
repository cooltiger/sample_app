require 'spec_helper'

describe "Static pages", :type => :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject {page}

  describe "Home page" do

    before {visit root_path}

    it { is_expected.to have_content('Sample App') }
    it { is_expected.to have_title(full_title('')) }
    it { is_expected.not_to have_content('| Home') }

    #it "works! (now write some real specs)" do
    #it "should have the content 'Sample App'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #get static_pages_index_path
      #response.status.should be(200)
      #visit '/static_pages/home'
      #visit root_path
      #expect(page).to have_content('Sample App')
    #end

    # it "should have the base title" do
      #visit '/static_pages/home'
      #visit root_path
    #   expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    # end

    # it "should not have a custom page title" do
      #visit '/static_pages/home'
      #visit root_path
    #   expect(page).not_to have_title('| Home')
    # end

  end
  describe "Help page" do
    before { visit help_path}
    it { is_expected.to have_content('Help')}
    it { is_expected.to have_title("#{base_title} | Help")}

#    #it "works! (now write some real specs)" do
#     it "should have the content 'Help'" do
#      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      #get static_pages_index_path
#      #response.status.should be(200)
      #visit '/static_pages/help'
 #      visit help_path
 #      expect(page).to have_content('Help')
 #      #expect(page).to have_title("wujun")
 #    end
 # #    it "should have the title 'Help'" do
 #      #visit '/static_pages/help'
 #      visit help_path
 #      expect(page).to have_title("#{base_title} | Help")
 #    end
  end

  describe "About page" do
    before { visit about_path }

    it { is_expected.to have_content('About')}
    it { is_expected.to have_title("#{base_title} | About")}

    # it "should have the content 'About Us'" do
    #   #visit '/static_pages/about'
    #   visit  about_path
    #   expect(page).to have_content('About Us')
    # end
    # it "should have the title 'About Us'" do
    #   #visit '/static_pages/about'
    #   visit about_path
    #   expect(page).to have_title("#{base_title} | About Us")
    # end
  end

  describe "Contact" do

    before { visit contact_path }

    it { is_expected.to have_content('Contact')}
    it { is_expected.to have_title("#{base_title} | Contact")}
    # it "should have the content 'Contact'" do
    #   #visit '/static_pages/contract'
    #   visit contact_path
    #   expect(page).to have_content('Contact')
    # end
    # it "should have the title 'Contact'" do
    #   #visit '/static_pages/contract'
    #    visit contact_path
    #   expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contact")
    # end
 end
end

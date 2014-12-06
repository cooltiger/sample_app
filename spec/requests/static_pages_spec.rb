require 'spec_helper'

describe "Static pages", :type => :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject {page}

  shared_examples_for "all static pages" do
    it { is_expected.to have_content('sample app') }
    it { is_expected.to have_title(full_title(page_title)) }
  end
  describe "Home page" do

    before {visit root_path}

    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }


  end
  describe "Help page" do
    before { visit help_path}

    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
    it { should have_content('Help') }

  end

  describe "About page" do
    before { visit about_path }

    it { is_expected.to have_content('About')}
    it { is_expected.to have_title("#{base_title} | About")}

  end

  describe "Contact" do

    before { visit contact_path }

    it { is_expected.to have_content('Contact')}
    it { is_expected.to have_title("#{base_title} | Contact")}
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign Up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

end

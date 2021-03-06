require 'spec_helper'

describe "Static pages", :type => :request do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  shared_examples_for "all static pages" do
    it { is_expected.to have_content('sample app') }
    it { is_expected.to have_title(full_title(page_title)) }
  end

  describe "Home page" do

    before { visit root_path }

    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: Faker::Lorem.sentence(5))
        FactoryGirl.create(:micropost, user: user, content: Faker::Lorem.sentence(5))
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower / following user count" do
        let(:other_user) { FactoryGirl.create(:user) }

        before do
          user.follow!(other_user)
          visit root_path
        end

        it { should have_link("followers", href: followers_user_path(user)) }
        it { should have_link("1 following", href: followings_user_path(user)) }
      end

    end
  end


  describe "Profile page" do

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit user_path(user)
      end

      it "should render the user's microposts" do
        user.microposts.each do |p|
          expect(page).to have_selector("li", text: p.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit user_path(user)
        end
        it { should have_link("0 followings", href: followings_user_path(user)) }
        it { should have_link("1 follower", href: followers_user_path(user)) }
      end
    end
  end


  describe "Help page" do
    before { visit help_path }

    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
    it { should have_content('Help') }
  end

  describe "About page" do
    before { visit about_path }

    it { is_expected.to have_content('About') }
    it { is_expected.to have_title("#{base_title} | About") }

  end

  describe "Contact" do

    before { visit contact_path }

    it { is_expected.to have_content('Contact') }
    it { is_expected.to have_title("#{base_title} | Contact") }
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
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

end

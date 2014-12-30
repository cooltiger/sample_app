require 'spec_helper'

describe "Micropost pages", :type => :request do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before do
        fill_in 'micropost_content', with: "Lorem ipsum"
      end
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end

      describe "have the success msg" do
        before { click_button "Post" }
        it { should have_selector('div.alert.alert-success', text: 'created') }
      end

      describe "have the right post count (single)" do
        before { click_button "Post" }
        it { should have_content("1 micropost") }
        it { should_not have_content("1 microposts") }
      end

      describe "have the right post count (multiple)" do
        before do
          click_button "Post"
          fill_in 'micropost_content', with: "Lorem ipsum 2"
          click_button "Post"
        end
        it { should have_content("2 microposts") }
      end

    end

    describe "micropost destroy" do
      before { FactoryGirl.create(:micropost, user: user) }

      describe "as a correct user" do
        before { visit root_path }
        it "should delete a micropost page" do
          expect { click_link("delete") }.to change(Micropost, :count).by(-1)
        end
      end
    end
  end

  describe "pagination" do

    before do
      30.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end

    after { user.microposts.delete_all }

    it { should have_selector('div.pagination') }

    it "should list each feed" do

      user.feed.paginate(page: 1).each do |feed_item|
        expect(page).to have_selector('li', text: feed_item.content)
      end
    end
  end

  describe "microposts in user's profile" do
    before do
     30.times { FactoryGirl.create(:micropost, user:user) }
    end

    describe "show another user's microposts" do
      let(:another_user) { FactoryGirl.create(:user) }
      before { visit user_path(another_user) }
      it { should_not have_link("delete") }
    end

    describe "show self's microposts" do
      before { visit user_path(user) }
      it { should have_link("delete") }
    end
  end
end


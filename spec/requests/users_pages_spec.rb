require 'spec_helper'

describe "User pages", :type => :request do

  subject { page }

  describe "profile page" do
    # ユーザー変数を作成するためのコードに置き換える。
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "follow and unfollow buttons " do

      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "follow other user" do
        before do
          visit user_path(other_user)
        end

        it "should increase a followed user" do
          expect { click_button "Follow" }.to change(user.followed_users, :count).by(1)
        end

        it "should increase a follower user " do
          expect { click_button "Follow" }.to change(other_user.follower_users, :count).by(1)
        end

        context "toggle the button" do
         before { click_button "Follow" }
          it { should have_title(full_title(other_user.name)) }
          it { should have_css("input[value='Unfollow']") }
        end
      end

      describe "unfollow other user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should increase a followed user" do
          expect{ click_button "Unfollow" }.to change(user.followed_users, :count).by(-1)
        end

        it "should increase a follower user " do
          expect{ click_button "Unfollow" }.to change(other_user.follower_users, :count).by(-1)
        end


        context "toggle the button" do
          before { click_button "Unfollow" }
          it { should have_title(full_title(other_user.name)) }
          it { should have_css("input[value='Follow']") }
        end
      end

    end

  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }

        it { should have_link('Sign out') }

      end

    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    before {
      sign_in user
      visit edit_user_path(user)
    }

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid infomation" do
      before { click_button "Save changes" }
      it { should have_content("error") }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    # below is deprecated
    # it { should have_selector('title', text: 'All users') }
    it { should have_title(full_title('All users')) }
    it { should have_selector('h1', text: 'All users') }

    describe "pagination" do

      before(:all) { 30.times {FactoryGirl.create(:user)} }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination')}
      it "should list each user" do

        # if show all the user without pagination
        # User.all.each do |user|
        #   expect(page).to have_selector('li', text: user.name)
        # end

        User.order('id').paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete user link" do

      it { should_not have_link('delete')}

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first))}

        it "should be able to delete another usser" do
          expect{ click_link('delete') }.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(:admin))}

      end

    end

    describe "update forbidden attributes" do
      let(:user) { FactoryGirl.create(:user) }
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        put user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end


  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    context "followed users list" do
      before do
        sign_in user
        visit followings_user_path(user)
      end

      it { should have_title(full_title('Followings')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    context "follower users list" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end




end

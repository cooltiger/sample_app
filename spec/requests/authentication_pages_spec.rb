require 'spec_helper'

describe "Authentication", :type => :request do

  subject { page }


  describe "Home page" do

    before {visit root_path}

    it { should_not have_link('Profile') }
    it { should_not have_link('Settings') }

  end

  describe "signin page" do

    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end


    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in(user) }

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end

  end

  describe "authenticate" do

    describe "for non sign in users" do

      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to vist a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after sign in success" do

          it "should render the desired page " do
            expect(page).to have_title('Edit user')
          end


          describe "when sign in again" do

            before do

              click_link "Sign out"
              click_link "Sign in"

              fill_in "Email", with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"

            end

            it { should have_title(full_title(''))}

          end

        end


      end

      describe "in the Users controller" do

        describe "visit the editin page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }

        end

        describe "submit to the update action" do
          # 更新の場合、実際表示ページがないため、capybaraが使えないため、railsのメソッドを使用する
          before { put user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

      end

    end


    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, name: "otherOne", email: "wrong@example.com") }


      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        # todo question なぜ no_capybaraでサインインする場合も current_userが設定されている？
        before { get edit_user_path(wrong_user) }
        specify "debug" do
          expect(response.body).not_to match(full_title('Edit user'))
        end
        # specify { expect(response.header).to eq 'test' }
        specify { expect(response).to redirect_to(root_url) }

        # 下記のやりかた、capybaraではないため、visit時、userの情報がない。 no loginのhome pageと同じ
        # before { visit edit_user_path(wrong_user)}
        # it { should_not have_title('Edit User') }
        # it { should have_title(full_title('')) }
        # it { should have_title('Sign in') }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
        # below deprecated when test patch
        # specify { response.should redirect_to(root_path) }
      end


      describe "when no_capybara, test goto root show home page" do
        # この場合、capybaraではないため、visit時、userの情報がない。 no loginのhome pageと同じ
        before { visit root_path }
        it { should have_title('Rails') }
        it { should have_link('Sign in') }
        # it { should have_link('Settings',    href: edit_user_path(user)) }
      end

    end

    describe "as non-admin user" do

      let(:user) { FactoryGirl.create(:user)}
      let(:non_admin) { FactoryGirl.create(:user)}

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a delete request to the User#delete action" do
        before { delete user_path(user)}
        specify { expect(response).to redirect_to(root_path) }
      end

    end

  end
end
# require 'rails_helper'

# RSpec.describe "UsersPages", :type => :request do
#   describe "GET /users_pages" do
#     it "works! (now write some real specs)" do
#       get users_pages_path
#       expect(response).to have_http_status(200)
#     end
#   end
# end

require 'spec_helper'

describe "User pages", :type => :request do

	subject { page }

	describe "profile page" do
		# ユーザー変数を作成するためのコードに置き換える。
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }
	end

	describe "signup" do

		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end
		end
	end

end

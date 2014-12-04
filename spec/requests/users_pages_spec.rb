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

	describe "signup page" do
		before { visit signup_path }

		it { is_expected.to have_content('Sign Up') }
		it { is_expected.to have_title(full_title('Sign Up')) }
	end
end

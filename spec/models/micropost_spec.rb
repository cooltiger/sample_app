# require 'rails_helper'
#
# RSpec.describe Micropost, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

require 'spec_helper'

describe Micropost do

	let(:user) { FactoryGirl.create(:user) }
	before { @micropost = user.microposts.build(content: "Test first content") }

	subject { @micropost}

	# repond_to means : check the property can be used in the model
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
  its(:user) { should == user}


	it { should be_valid }

	describe "when user_id is not present" do

	  before { @micropost.user_id=nil }
		it { should_not be_valid }

	end

	describe "accessible attributes" do
		it "should not allow to access to user_id" do
		 expect do
			 Micropost.new(user_id: user.id)
		 end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

end

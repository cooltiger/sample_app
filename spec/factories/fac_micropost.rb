FactoryGirl.define do
	factory :micropost do
		content "Test a first post"
		user
	end
end
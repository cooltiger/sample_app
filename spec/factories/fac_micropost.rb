FactoryGirl.define do
  factory :micropost do
    sequence(:content)   { |n| "Test post no. #{n}" }
    user
  end
end
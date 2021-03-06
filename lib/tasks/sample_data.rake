namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.jp",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)

  admin2 = User.create!(name: "Wu Jun",
                         email: "cooltigerjp@gmail.com",
                         password: "aaa111",
                         password_confirmation: "aaa111")
  admin2.toggle!(:admin)

  admin3 = User.create!(name: "Yu Zhenjiang",
                        email: "gyo@gmail.com",
                        password: "aaa111",
                        password_confirmation: "aaa111")
  admin3.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.jp"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.limit(6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = User.find_by_email("cooltigerjp@gmail.com")
  followed_users = users[2..50]
  follower_users = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  follower_users.each { |follower| follower.follow!(user) }
end

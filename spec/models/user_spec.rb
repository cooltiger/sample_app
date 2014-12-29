require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:object_id) }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts)}
  it { should respond_to(:feed)}
  it { should respond_to(:relationships)}
  it { should respond_to(:reverse_relationships)}
  it { should respond_to(:followed_users)}
  it { should respond_to(:follower_users)}

  it { should respond_to(:following?)}
  it { should respond_to(:follow!)}


  it { should be_valid }
  it { should_not be_admin}

  describe "with admin attribute set to true" do
    before do
      # @user.admin=1
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin}

  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51}
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com abcあ@gmail.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address is not case sentitive" do
    before do
      user2 = @user.dup
      user2.email = @user.email.upcase
      user2.save
    end

    it { should_not be_valid}
  end

  describe "email address with mixed case" do
    let(:mixcasemail) { "Foo@Example.com" }

    it "should be saved as all lower case" do
      @user.email = mixcasemail
      @user.save
      expect(@user.reload.email).to eq mixcasemail.downcase
    end

  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "misinput" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      # rspec 3 以上は be_false から be_false　へ変更
      specify { expect(user_for_invalid_password).to be_falsey }
    end

  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do

    before { @user.save }
    let!(:older_mpost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago )}
    let!(:newer_mpost) { FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago )}

    it  "should have the right microposts in the right order" do
      expect(@user.microposts).to eq [ newer_mpost, older_mpost]

      # below is deprecated
      # @user.microposts.should == [ newer_mpost, older_mpost ]
    end

    it "should destroy associated microposts" do
      # expect { @user.destroy }.to change(Micropost, :count).by(-2)
      micropost_ids = @user.microposts.ids
      @user.destroy
      expect(micropost_ids.count).to be > 0
      micropost_ids.each do |id|
        expect(Micropost.find_by_id(id)).to be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) { FactoryGirl.create(:micropost, user: FactoryGirl.create(:user)) }

      its(:feed) { should include(older_mpost)}
      its(:feed) { should include(newer_mpost)}
      its(:feed) { should_not include(unfollowed_post)}
    end

  end


  describe "following and followed" do
    let(:other_user) { FactoryGirl.create(:user) }

    before do
      @user.save
      @user.follow!(other_user)
    end

    # be_following mean : boolean vertification of following method
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:follower_users) { should include(@user) }
    end

    context "unfollow other user"  do
      before do
        @user.unfollow!(other_user)
      end

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }

      describe "followed user" do
        subject { other_user }
        its(:follower_users) { should_not include(@user) }
      end

    end

  end

  # below is same as :  it { should respond_to(:name) }
  # it "should respond to 'name'" do
  #  expect(@user).to respond_to(:name)
  # end


  # below is same as :  it { should be_valid }
  # it "should be valid" do
  #  expect(@user).to be_valid
  # end

end

# require 'rails_helper'
#
# RSpec.describe User, :type => :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end

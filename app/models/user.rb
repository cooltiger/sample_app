class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", dependent: :destroy
  has_many :follower_users, through: :reverse_relationships, source: :follower

  # below can not user in rails 4
  attr_accessible :name, :email, :password, :password_confirmation

  has_secure_password

  # 保存する前に、強制的に文字を小文字に変換する
  before_save { self.email = email.downcase}

  # can pass a parameter by a method name
  before_create :create_remember_token

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
   uniqueness: { case_sensitive: false }
  # validates_presence_of(:email)
  # validates_presence_of(:name)
  validates :password, length: { minimum: 6 }


  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def create_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end

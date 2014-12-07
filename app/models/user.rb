class User < ActiveRecord::Base

	has_secure_password

	# 保存する前に、強制的に文字を小文字に変換する
	before_save { self.email = email.downcase}

	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
	 uniqueness: { case_sensitive: false }
	# validates_presence_of(:email)
	# validates_presence_of(:name)
	validates :password, length: { minimum: 6 }
end

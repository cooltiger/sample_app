class User < ActiveRecord::Base

	has_secure_password

	# 保存する前に、強制的に文字を小文字に変換する
	before_save { self.email = email.downcase}

	# before_create :create_remember_token
	# TODO 上記：なぜ before_createの後に、「：」を使って、メソッドを利用する？
	before_create do
		create_remember_token
	end

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

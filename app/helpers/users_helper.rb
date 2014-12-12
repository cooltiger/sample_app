module UsersHelper
	# 与えられたユーザーのGravatar (http://gravatar.com/) を返す。
	# @param [Object] options
	def gravatar_for(user, options = {:size=>10, :color=>'red' })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}&c=#{options[:color]}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end
end

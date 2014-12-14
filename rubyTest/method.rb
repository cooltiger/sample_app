#!/usr/bin/env ruby

class Foo

	def hi
		p "test"
	end

	def abc=(user)
		@current_user = user
	end

	def efg
		@current_user
	end

	def [](key)
		p key
	end
end


f = Foo.new
f.abc='wujun'
name = f.efg

p f.efg
name[0] ='l'
p f.efg

p f['testkey']
  f.send('hi')
	f.method(:hi).call
str=SecureRandom.urlsafe_base64
p str
p Digest::SHA1.hexdigest(str)

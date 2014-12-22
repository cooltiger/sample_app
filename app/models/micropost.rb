class Micropost < ActiveRecord::Base
	belongs_to :user
	attr_accessible :content
	validates :user_id, presence: true

	# default_scope order: 'microposts.created_at DESC'
end

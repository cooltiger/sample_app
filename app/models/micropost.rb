class Micropost < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  # define the order by default_scope
  default_scope  { order 'microposts.created_at DESC' }

  self.per_page = 10

  def self.from_users_followed_by(user)
    followed_user_ids = user.followed_user_ids
    where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  end

end

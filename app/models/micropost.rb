class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user 																					#creates an association with the user model showing that a micropost belongs to a user
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'

  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
  	followed_users_ids = "SELECT followed_id FROM relationships
  						  WHERE follower_id = :user_id"
  	where("user_id IN ( :followed_users_ids ) OR user_id = :user_id", followed_users_ids: followed_users_ids, user_id: user)
  end
end

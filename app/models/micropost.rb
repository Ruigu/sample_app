class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user 																					#creates an association with the user model showing that a micropost belongs to a user
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  default_scope order: 'microposts.created_at DESC'
end

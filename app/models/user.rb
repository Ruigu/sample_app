# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :username, :password, :password_confirmation													                             #attr_accessible tells Rails which attributes of the model are accessible(i.e, which attributes can be modified automatically by outside users such as submitting requests on browsers).
  has_secure_password																							                                                       #method gives a secure way to create and authenticate new users, ensures encrypted passwords match with encrpted password on the password digest on the database
  has_many :microposts, dependent: :destroy                                                                              #creates an association with the micropost model showing a user has many microposts and verifies the existence of a micropost attribute
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy                                               #creates an association with the relationship model showing a user has followers and once they are deleted all their relationships are also deleted
  has_many :followed_users, through: :relationships, source: :followed
  
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy

  has_many :followers, through: :reverse_relationships, source: :follower


  before_save { |user| user.email = email.downcase } 																                                     #ensuring email uniqueness by downcasing the email attribute to all be in lowercase
  before_save { |user| user.username = username.downcase }
  before_save :create_remember_token 																				                                             #rails looks for a method called create_remeber_token and run it b4 saving a user

  def feed
    Micropost.where("user_id = ?", id)                                                                                  #the ? ensures that id is properly escaped before being included in SQL query thus avoiding a serious security hole called SQL injection
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  #this helps to use the model name in the url instead of id
  def to_param
    normalized_name = username.gsub(/[^a-zA-Z0-9\_\-\.]/, '')
  "#{normalized_name}"
  end
  
  private
  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64 															                                   #self ensures tht the assignment sets the user's remember token so tht tz written to the database along with other attributes when a user is saved. wihout self ruby would create a new local variable instead of using the already defined variable
    end

    

  #validations
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 															                                 #regular expession(regex) to define format
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } 		       #VALID_EMAIL_REGEX is a ruby constant so its value cant change
  validates_format_of :username, :with => /^[a-zA-Z\d_]+$/,:message => "cannot have a space"
  validates_presence_of :username
  validates_uniqueness_of :username, case_sensitive: false
  validates :password, length: { minimum: 6 }, presence: true
  validates :password_confirmation, presence: true
end

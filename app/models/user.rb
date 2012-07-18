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
  attr_accessible :email, :name, :password, :password_confirmation													#attr_accessible tells Rails which attributes of the model are accessible(i.e, which attributes can be modified automatically by outside users such as submitting requests on browsers).
  has_secure_password																								#method gives a secure way to create and authenticate new users, ensures encrypted passwords match with encrpted password on the password digest on the database

  before_save { |user| user.email = email.downcase } 																#ensuring email uniqueness by downcasing the email attribute

  #validations
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i 															#regular expession(regex) to define format
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false } 		#VALID_EMAIL_REGEX is a ruby constant so its value cant change
  validate :password, length: { minimum: 6 }
  validate :password_confirmation
end

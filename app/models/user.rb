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
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password #Rails method that magically gives us a secure way to create/authenicate users 
	before_save :create_remember_token #looks for a method (create_remember_token) and calls it before saving the user


	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, length: { minimum:6 }
	validates :password_confirmation, presence: true


private #all methods defined after private are automatically internal to class (hidden)
	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
		#Self is used because otherwise asssignment would create a local varaible
		#using self makes sure it is written to the DB
	end

end

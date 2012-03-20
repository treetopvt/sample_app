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

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com",
  							password: "foobar", password_confirmation: "foobar") } 
  							#create a user before performing tests

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }


  it { should be_valid }

  describe "when name is not present" do
	before { @user.name = " " }
	it { should_not be_valid }
  end
  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when user name is too long" do
  	before { @user.name = "a"*51 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo.] #%w makes an array of strings
  	invalid_addresses.each do |invalid_address|
  		before { @user.email = invalid_address }
  		it { should_not be_valid }
	end
  end

  describe "when email format is valid" do
  	valid_addresses = %w[user@foo.com A_USER@f.b.org frst.last@foo.jp a+b@baz.cn]
  	valid_addresses.each do |valid_address|
  		before { @user.email = valid_address }
  		it { should be_valid }
  	end
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when user password is not present" do
  	before { @user.password = @user.password_confirmation = " " } #sets both params to empty string
  	it { should_not be_valid }
  end

  describe "when password doesn't match confirm" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end

  describe "when password is nil" do
  	before { @user.password = nil }
  	it { should_not be_valid }
  end

  describe "return value of authenicate method" do
  	before { @user.save }
  	let(:found_user) {User.find_by_email(@user.email)}

  	describe "with valid password" do
  		it { should == found_user.authenticate(@user.password) }
  	end
  	describe "with invalid password" do
  		let(:user_with_invalid_password) { found_user.authenticate("invalid") }

  		it { should_not == user_with_invalid_password }
  		specify { user_with_invalid_password.should be_false } #specify is a synonym for let, reads better
  	end

  end

  describe "with a password that is too short" do
  	before { @user.password = @user.password_confirmation = "a"*5 }
  	it { should_not be_valid } #tutorial says should be_invalid
  end

end

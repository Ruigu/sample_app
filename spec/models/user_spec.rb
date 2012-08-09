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
  
  #pending "add some examples to (or delete) #{__FILE__}"

  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }                           #verifying that a user has micropost attributes
  it { should respond_to(:feed) }                                 #verifying that a user homepage also shows his feeds and of his followers

  it { should be_valid}				               				              #verifying that @user object id valid
  it { should_not be_admin}

  it { should respond_to(:authenticate) }                         #require a user object to respond to authenticate

  #test for an admin attribute
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)                                       #user toggle! method to flip the admin attribute 4rm false to true
    end

    it { should be_admin }                                        #user should have an admin? boolean method
  end

  #test that user should have name (Name validation)
  describe "when name is not present" do
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  #test that user should have an email (Email Validation)
  describe "when email is not present" do
  	before { @user.email = " "}
  	it { should_not be_valid}
  end

  #test to ensure users do not enter a blank password
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid}
  end

  #test of a password mismatch case
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  #testing the order of user's microposts
  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    #test that micropost are destroyed when users are
    it "should destroy associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    #test for the status feed
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end

  #test to ensure that password_confirmation field is not empty
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  #test for length validation on passwords
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  #test for user authentication
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end

  #test that users name should not have more than 50characters (Length Validation)
  describe "when name is too long" do
  	before { @user.name = "a" * 51}
  	it { should_not be_valid}
  end

  #test email format validation
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  #test for rejection of duplicate email addresses
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  #test for a valid (nonblank) remember token
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end

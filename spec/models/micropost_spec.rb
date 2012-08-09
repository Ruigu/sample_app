require 'spec_helper'

describe Micropost do
	#test to ensure that a micropost responds to given attributes
	let(:user) { FactoryGirl.create(:user) }
	
	before { @micropost = user.microposts.build(content: "Lorem ipsum") }
	

	subject { @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) } 																			#tests with the second line for micropost's user association
 	its(:user) { should == user }

	it { should be_valid }

	#test to ensure that the user_id isn't accessible
	describe "accessible attributes" do
		it "should not allow access to user_id" do
			expect do
				Micropost.new(user_id: user.id)
			end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	#test for validity of a new micropost(it tests for presence of user_id attribute inorder for micropost to be valid)
	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	#test for the micropost model validations
	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
    	it { should_not be_valid }
    end

  	describe "with blank content" do
  		before { @micropost.content = " " }
    	it { should_not be_valid }
  	end

  	describe "with content that is too long" do
  		before { @micropost.content = "a" * 141 }
    	it { should_not be_valid }
  	end
end

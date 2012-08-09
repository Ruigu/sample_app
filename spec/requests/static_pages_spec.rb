require 'spec_helper'

describe "StaticPages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }
    
    it { should have_selector('h1', text: 'Sample App') } 
    it { should have_selector 'title', text: full_title('') }
    it { should have_selector 'title', text: '| Home' }

    #test for rendering the fedd on the Homepage
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)                                                                  #this line assumes that each feed has a unique CSS id so as to generate a match for each item(the first # in li##{} is Capybara syntax for CSS id, whereas the second is beginning of a Ruby string interpolation#{})
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_selector('h1', text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
    end

  describe "About page" do
    before { visit about_path }
    
    it { should have_selector('h1', text: 'About Us') }
    it { should have_selector('title', text: full_title('About Us')) }
    end

  describe "Contact Page" do
    before { visit contact_path }

    it { should have_selector('h1', text: 'Contact') }
    it { should have_selector('title', text: full_title('Contact')) }
    end

  describe "Carrers Page" do
    before { visit carrers_path }
    
    it { should have_selector('h1', text: 'Carrers') }
    it { should have_selector('title', text: full_title('Carrers')) }
    end

end
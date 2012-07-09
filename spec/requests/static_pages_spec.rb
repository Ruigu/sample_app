require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do
    
    it "should have the h1 'Sample App'" do
      visit root_path
      page.should have_selector('h1', :text => 'Sample App') 
   end

   it "should have the base title" do
   	visit root_path
   	page.should have_selector('title', 
   					:text => "Ruby on Rails Tutorial Sample App")
   end

   it "should have a custom page title" do
    visit root_path
    page.should have_selector('title', :text => '| Home')
  end
end

  describe "Help page" do

    it "should have the h1 'Help'" do
      visit help_path
      page.should have_selector('h1', :text => 'Help')
    end
    
    it "should have the base title" do
      visit help_path
      page.should have_selector('title', 
            :text => "Ruby on Rails Tutorial Sample App")
    end

    it "should have a custom page title" do
      visit help_path
      page.should have_selector('title', :text => '| Help')
    end
  end

  describe "About page" do
    
    it "should have the h1 'About Us'" do
      visit about_path
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the base title" do
      visit about_path
      page.should have_selector('title',
            :text => "Ruby on Rails Tutorial Sample App")
    end

    it "should have a custom page title" do
      visit about_path
      page.should have_selector('title', :text => '| About Us')
    end
  end

  describe "Contact Page" do
    
    it "should have the h1 'Contact'" do
      visit contact_path
      page.should have_selector('h1', :text => 'Contact')
    end

    it "should have the base title" do
      visit contact_path
      page.should have_selector('title', 
            :text => "Ruby on Rails Tutorial Sample App" )
    end

    it "should have a custom page title" do
      visit contact_path
      page.should have_selector('title', :text => '| Contact')
    end
  end


  describe "Carrers Page" do
    it "should have h1 'Carrers'" do
      visit carrers_path
      page.should have_selector('h1', :text => 'Carrers')
    end

    it "should have the base title" do
      visit carrers_path
      page.should have_selector('title', 
            :text => "Ruby on Rails Tutorial Sample App")
    end

    it "should have a custom page title" do
      visit carrers_path
      page.should have_selector('title', :text => '| Carrers')
    end
  end

end
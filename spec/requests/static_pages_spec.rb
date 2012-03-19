require 'spec_helper'

describe "StaticPages" do

  let(:base_title){
    "Ruby On Rails Sample Tutorial App"
  }

  	describe "Home page" do
  		it "should have the content 'Sample App'" do
  			visit '/static_pages/home'
  			page.should have_selector('h1', :text=>'Sample App')
  		end
      it "should have the base title" do
        visit '/static_pages/home'
        page.should have_selector('title', :text=> "#{base_title}")
      end
      it "should not have a custom title page" do
        visit '/static_pages/home'
        page.should_not have_selector('title', :text=>' | Home')
      end
  	end

  	describe "Help page" do
      it "should have the right title" do
        visit '/static_pages/help'
        page.should have_selector('title', :text=> " | Help")
      end
  		it "should have the content 'Help'" do
  			visit '/static_pages/help'
  			page.should have_selector('h1', :text=>'Help')
  		end
  	end

  	describe "About Page" do
      it "should have the right title" do
        visit '/static_pages/about'
        page.should have_selector('title', :text=> "#{base_title} | About Us")
      end
  		it "should have the content 'About Us'" do
  			visit '/static_pages/about'
  			page.should have_selector('h1', :text=>'About Us')
  		end
  	end

    describe  "Contact Page" do
      it "should have the correct title" do
        visit '/static_pages/contact'
        page.should have_selector('title', :text=>"#{base_title} | Contact")
      end
      it "should have the content 'Contact'" do
        visit '/static_pages/contact'
        page.should have_selector('h1', :text=>'Contact')
      end
    end
end

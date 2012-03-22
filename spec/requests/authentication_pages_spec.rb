require 'spec_helper'

describe "Authentication" do
	subject { page }
	describe "signin page" do
		before { visit signin_path }

		it {should have_selector('h1', text:'Sign in') }
		it {should have_selector('title', text:full_title('Sign in')) }

	describe "Authentication" do

		describe "Authorization" do

			describe "as wrong user" do
				let(:user) { FactoryGirl.create(:user) }
				let(:wrong_user) { FactoryGirl.create(:user, email:"wrong@example.com") }
				before { sign_in user }

				describe "Visiting Users#edit page" do
					before { visit edit_user_path(wrong_user) }
					it { should have_selector('title', text: full_title('')) }
				end

				describe "submitting a PUT request to the Users#update action" do
					before { put user_path(wrong_user) } #put is an update?
					specify{ response.should redirect_to(root_path) }
				end
			end

			describe "for non-signed-in users" do
				let(:user) { FactoryGirl.create(:user) }

				describe "in the Users controller" do
					describe "visiting the edit page" do
						before { visit edit_user_path(user) }
						it { should have_selector('title', text:full_title('Sign in')) }
					end

					describe "submitting to the update action" do
						before { put user_path(user) } #this issues a PUT request directly to /users/1 which gets
						#routed to the update action of the Users controller. This is necessary because there is
						#no way for a browser to directly visit the update action, so Capybara (testing) can't do it.
						#FYI, Rails tests also support get, post, and delete (4 main verbs)
						specify { response.should redirect_to(signin_path) }
					end
				end
			end
		end
	end


		describe "when invalid information is entered" do
			before { click_button "Sign in" }

			it {should have_selector('title', text: 'Sign in') }
			it { should have_error_message('Invalid') } #custom RSPEC Method defined in utilites.rb
			#it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }

				it { should_not have_selector('div.alert.alert-error') }
				
			end
		end

		describe "when valid information is entered" do
			let(:user) { FactoryGirl.create(:user) }
			before { #used to be : before do end
				valid_signin(user) }
				# fill_in "Email", 	with: user.email
				# fill_in "Password", with: user.password
				# click_button "Sign in"
			#end

			it { should have_selector('title', text: user.name) }
			it { should have_link('Profile', href: user_path(user)) } #have_link check to see if anchor exists with path
			it { should have_link('Sign out', href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }
			it { should have_link('Settings', href: edit_user_path(user)) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end


end

require 'spec_helper'

describe "User Pages" do
	subject {page}

	describe "edit" do
		let(:user) { FactoryGirl.create(:user) }
		#before { visit edit_user_path(user) }
		before do
			sign_in user
			visit edit_user_path(user)
		end

		describe "page" do
			it { should have_selector('h1',		text:"Update your profile") }
			it { should have_selector('title',		text:full_title('Edit User')) }
			it { should have_link('change',		href:"http://gravatar.com/emails") }
		end

		describe "with invalid edit information" do
			before { click_button "Save changes" }
			it { should have_content('error') }
		end

		describe "with valid edit information" do
			let(:new_name) { "New Name"}
			let(:new_email) { "newemail@example.com" }
			before do
				fill_in "Name", 			with:new_name
				fill_in "Email",			with:new_email
				fill_in "Password",			with:user.password
				fill_in "Confirmation",		with:user.password
				click_button "Save changes"
			end

			it { should have_selector('title', text: new_name) }
			it { should have_selector('div.alert.alert-success') }
			it { should have_link('Sign out', :href => signout_path) }
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email } #same as it, but sounds better in this case

		end
	end

	describe "signup page" do
		before {visit signup_path}

		it { should have_selector('h1', text:'Sign up') }
		it { should have_selector('title', text:full_title('Sign up')) }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button "Create my account" }.not_to change(User, :count)

			end
			describe "error messages" do
				before { click_button "Create my account" }
				it { should have_selector('title', text: 'Sign up') }
				it { should have_content('error') }
			end

		end
		describe "with valid information" do
			before do
				fill_in "Name", 			with:"Example User"
				fill_in "Email",			with:"user@example.com"
				fill_in "Password",			with:"foobar"
				fill_in "Confirmation",		with:"foobar"
			end
			it "should create a user" do
				expect do
					click_button "Create my account"
				end.to change(User, :count).by(1)

			end
			describe "after saving the user" do
				before { click_button "Create my account" }
				let(:user) { User.find_by_email('user@example.com') }

				it { should have_selector('title', text: user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }

				it { should have_link('Sign out' ) } #makes sure user has been signed in
			end
		end


	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

  end

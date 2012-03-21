class SessionsController < ApplicationController
	def new
  	#@user = User.new(params[:user])
  	# @session  = Session.new()
  	# if @session.save
  	# 	#handle a sucessful save
  	# 	flash[:success] = "Welcome to the sample App!"
  	# 	redirect_to @user
  	# else
  	# 	render 'new'
  	# end		
	end

	def create
		user = User.find_by_email(params[:session][:email])
		if user && user.authenticate(params[:session][:password])
			#sign in the user and redirect to the user's show page
			sign_in user
			redirect_to user
		else
			#create an error message and re-render the signin form
			flash.now[:error] = 'Invalid email/password combination' #only displays messages on rendered pages
			#disappears as soon as an additional request is made
			render 'new'
		end
		
	end

	def destroy
	end
end

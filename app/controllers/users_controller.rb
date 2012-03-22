class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update]
  #before filter applies to every action in a controller.  By defining only update and edit, the function,
  #"signed_in_user" is only called with the update and edit requests.
  before_filter :correct_user,  only: [:edit, :update]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		#handle a sucessful save
      sign_in @user
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
   #@user = User.find(params[:id]) #can remove because the correct_user before filter defines @user
  end

  def update
   # @user = User.find(params[:id])#can remove because the correct_user before filter defines @user
    if @user.update_attributes(params[:user])
      #Successful update
      flash[:success] = "Profile Updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def signed_in_user

      redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      logger.debug "Is current user the same as user? : #{current_user?(@user)}"
      redirect_to(root_path) unless current_user?(@user)
    end

end

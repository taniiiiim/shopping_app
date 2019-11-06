class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :exit, :destroy]
  before_action :correct_user, only: [:show, :edit, :update, :exit, :destroy]

  def show
    @user = User.find(params[:id])
    @orders = @user.orders.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end


  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def exit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user) && @user.authenticate(user_params[:password])
      @user.destroy
      flash[:success] = "User deleted"
      log_out
      redirect_to root_url
    else
      render 'exit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :real_name, :email, :gender, :birthdate, :code, :address,
                                 :password, :password_confirmation)
  end

end

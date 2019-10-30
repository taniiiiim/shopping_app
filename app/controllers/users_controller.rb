class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to Taniiiiim Shopping App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def index
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :real_name, :email, :gender, :birthdate, :code, :address,
                                 :password, :password_confirmation)
  end

end

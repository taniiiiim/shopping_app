class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include CartHelper

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "Please log in with correct user."
      redirect_to(root_url)
    end
  end

  def admin_user
    unless current_user.admin
      flash[:danger] = "Please log in with correct user."
      redirect_to(root_url)
    end
  end

  def correct_user_for_order
    @order = Order.find(params[:id])
    unless current_user == User.find(@order.user_id)
      flash[:danger] = "Please log in as correct user."
      redirect_to root_url
    end
  end

end

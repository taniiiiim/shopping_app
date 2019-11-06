class OrdersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_for_order, only: [:show, :edit, :update, :cancel, :destroy]

  def show
    @order = Order.find(params[:id])
  end

  def new
  end

  def create
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(order_params)
      @order.send_order_update_email
      flash[:success] = "Order destination changed!"
      redirect_to @order
    else
      render 'edit'
    end
  end

  def cancel
  end

  def destroy
    @order = Order.find(params[:id])
    @user = User.find(@order.user_id)
    if current_user?(@user) && @user.authenticate(order_params[:password])
      @order.destroy
      @order.send_order_delete_email
      flash[:success] = "Order deleted"
      redirect_to @user
    else
      render 'cancel'
    end
  end

  private

  def order_params
    params.require(:order).permit(:code, :address, :password, :password_confirmation)
  end

end

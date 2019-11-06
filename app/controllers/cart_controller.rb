class CartController < ApplicationController
  before_action :logged_in_user
  before_action :check_expiration, only: [:show, :edit, :update, :destroy]

  def show
    @order = Order.find(params[:id])
  end

  def create
    @product = Product.find(params[:product_id])
    @stock = Stock.find_by(product_id: @product.id)

    if 0 < params[:detail][:amount].to_i && params[:detail][:amount].to_i < @stock.stock
      if (@order = Order.find_by(user_id: current_user.id, ordered: false))
        if (@detail = @order.details.find_by(product_id: @product.id))
          @detail.update_attribute(:amount, params[:detail][:amount])
          @order.update_attribute(:cart_created_at, Time.zone.now)
          flash[:success] = "Product in your cart updated!"
        else
          Detail.create!(order_id: @order.id, product_id: @product.id, amount: params[:detail][:amount])
          @order.update_attribute(:cart_created_at, Time.zone.now)
          flash[:success] = "Product added to your cart!"
        end

      else
        @order = Order.create(user_id: current_user.id, ordered: false, cart_created_at: Time.zone.now)
        Detail.create(order_id: @order.id, product_id: @product.id, amount: params[:detail][:amount])
        flash[:success] = "Cart created!"
        flash[:success] += "Product added to your cart!"
      end
      create_cart(@order)
      redirect_to @product
    else
      flash[:danger] = "No stocks for this product!"
      redirect_to @product
    end

  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:order_id])
    if @order.update_attributes(code: params[:order][:code], address: params[:order][:address])
      @order.update_attributes(ordered: true, ordered_at: Time.zone.now)
      destroy_cart
      reduce_stocks(@order)
      @order.send_order_create_email
      flash[:success] = "Order confirmed!"
      redirect_to @order
    else
      render 'edit'
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    flash[:success] = "Order deleted"
    redirect_to root_url
  end

  private

    def check_expiration
      @order = Order.find(params[:id])
      if !(any_carts?) || @order.cart_created_expired?
        destroy_cart
        @order.destroy if @order
        flash[:danger] = "The cart has expired."
        redirect_to root_url
      end
    end

end

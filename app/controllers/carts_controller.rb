class CartController < ApplicationController
  before_action :logged_in_user
  before_action :available_cart

  def show
  end

  def create
    @order = Order.find_by(user_id: current_user.id, ordered: false)
    @product = Product.find(params[:product_id])
    @stock = Stock.find_by(product_id: @product.id)

    if 0 < params[:detail][:amount].to_i && params[:detail][:amount].to_i < @stock.stock
      if @order
        @detail = @order.details.find_by(product_id: @product.id)
        if @detail
          @detail.update_attribute(:amount, params[:amount])
          flash[:success] = "Product in your cart updated!"
        else
          @detail = Detail.create!(order_id: @order.id, product_id: @product.id, amount: params[:detail][:amount])
          flash[:success] = "Product added to your cart!"
        end

      else
        @order = Order.create(user_id: current_user.id, ordered: false)
        Detail.create(order_id: @order.id, product_id: @product.id, amount: params[:detail][:amount])
        flash[:success] = "Cart created!"
        flash[:success] += "Product added to your cart!"
      end
      redirect_to @product
    else
      flash[:danger] = "No stocks for this product!"
      redirect_to @product
    end

  end

  def update
    render 'show'
  end

  def destroy
  end

  private
    def available_cart
#      unless session[:order_id] || cookies.signed()
    end


end

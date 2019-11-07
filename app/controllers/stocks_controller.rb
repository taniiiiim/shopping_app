class StocksController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def update
    @stock = Stock.find(params[:stock_id])
    @product = Product.find(@stock.product_id)
    if params[:stock][:stock].to_i >= 0
      if @stock.update_attribute(:stock, params[:stock][:stock])
        flash[:success] = "Stock updated!"
        redirect_to @product
      else
        render 'products/edit'
      end
    else
      flash[:danger] = "invalid stock information!"
      redirect_to edit_product_path(@product)
    end
  end

end

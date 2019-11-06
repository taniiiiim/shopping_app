class StocksController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user

  def update
    @stock = Stock.find(params[:stock_id])
    if @stock.update_attribute(:stock, params[:stock][:stock])
      flash[:success] = "Stock updated!"
      redirect_to Product.find(@stock.product_id)
    else
      render 'products/edit'
    end
  end

end

class ProductsController < ApplicationController
  before_action :logged_in_user,  only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user,      only: [:new, :create, :edit, :update, :destroy]
  before_action :ordered_product, only: [:update, :destroy]

  def show
    @product = Product.find(params[:id])
    @detail = Detail.new
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      Stock.create!(product_id: @product.id, stock: 0)
      flash[:success] = "A new product added!"
      redirect_to @product
    else
      render 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
    @stock = Stock.find_by(product_id: @product.id)
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      flash[:success] = "A product updated"
      redirect_to @product
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product
      @product.destroy
      flash[:success] = "A product deleted!"
      redirect_to root_url
    else
      flash[:success] = "Delete failed!"
      redirect_to root_url
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :picture, :gender_id, :size_id, :category_id, :price, :abstract)
  end

  def ordered_product
    @product = Product.find(params[:id])
    if Detail.find_by(product_id: @product.id)
      flash[:danger] = "This product has already ordered!"
      redirect_to root_url
    end
  end

end

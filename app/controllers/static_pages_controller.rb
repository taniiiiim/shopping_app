class StaticPagesController < ApplicationController
  def home
    @feed_items = Product.all.paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contact
  end
end

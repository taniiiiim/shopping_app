class SearchController < ApplicationController

  def new
    @feed_items = Product.all.paginate(page: params[:page])
    @feed_items = @feed_items.where("name like ?", "%" + params[:name] + "%") if params[:name].present?
    @feed_items = @feed_items.where("gender_id = ?", params[:gender_id]) if params[:gender_id].present?
    @feed_items = @feed_items.where("size_id = ?", params[:size_id]) if params[:size_id].present?
    @feed_items = @feed_items.where("category_id = ?", params[:category_id]) if params[:category_id].present?
    @feed_items = @feed_items.where("price <= ?", params[:price]) if params[:price].present?

    render 'static_pages/home'
  end

end

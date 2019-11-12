require 'rails_helper'

RSpec.describe SearchController, type: :request do

  before do
    @gender = Gender.create!(gender: "Men's")
    @category = Category.create!(category: "coat")
    @size = Size.create!(size: "S")
    @product = Product.create!(name: "Coat S",
                    gender_id: @gender.id,
                    category_id: @category.id,
                    size_id: @size.id,
                    price: 1500,
                    abstract: "A popular coat",
                    picture: "rails.png")
    @stock = Stock.create!(product_id: @product.id, stock: 100000)
  end

  it "successful search" do
    get '/search'
    expect(response).to have_http_status :success
    expect(response).to render_template "static_pages/home"
  end

  it "successful search with params" do
    get '/search', params: { name: "coat", gender_id: 1, size_id: 1, category_id: 1, price: 5000 }
    expect(response).to have_http_status :success
    expect(response).to render_template "static_pages/home"
  end

end

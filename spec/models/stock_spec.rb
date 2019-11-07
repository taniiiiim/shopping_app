require 'rails_helper'

RSpec.describe Stock, type: :model do

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

  it "product_id should be present" do
    @stock.product_id = nil
    expect(@stock).not_to be_valid
  end

  it "stock should be present" do
    @stock.stock = nil
    expect(@stock).not_to be_valid
  end

  it "stock should not be negative" do
    @stock.stock = -1
    expect(@stock).not_to be_valid
    @stock.stock = 0
    expect(@stock).to be_valid
    @stock.stock = 1
    expect(@stock).to be_valid
  end

  it "stock should not be larger than 100000" do
    @stock.stock = 99999
    expect(@stock).to be_valid
    @stock.stock = 100000
    expect(@stock).to be_valid
    @stock.stock = 100001
    expect(@stock).not_to be_valid
  end

end

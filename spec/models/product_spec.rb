require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "valid product definition" do

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
      @user = User.create!( name:  "Example User",
                   real_name: "Example",
                   email: "example@railstutorial.org",
                   password: "password",
                   password_confirmation: "password",
                   gender: "Male",
                   birthdate: "1993-12-01",
                   code: "241-0836",
                   address: "神奈川県横浜市旭区万騎が原64-23",
                   activated: true )
      @stock = Stock.new(product_id: @product.id)
    end

    it "valid product" do
      expect(@product).to be_valid
    end

    it "name should not be blank" do
      @product.name = ""
      expect(@product).not_to be_valid
    end

    it "name should not be larger than 100 words" do
      @product.name = "a" * 99
      expect(@product).to be_valid
      @product.name = "a" * 100
      expect(@product).to be_valid
      @product.name = "a" * 101
      expect(@product).not_to be_valid
    end

    it "name should be unique" do
      @product1 = Product.new(name: "Coat S",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 2000,
                      abstract: "A popular coat, too",
                      picture: "rails.png")
      expect(@product1).not_to be_valid
    end

    it "gender_id should not be blank" do
      @product.gender_id = nil
      expect(@product).not_to be_valid
    end

    it "category_id should not be blank" do
      @product.category_id = nil
      expect(@product).not_to be_valid
    end

    it "size_id should not be blank" do
      @product.size_id = nil
      expect(@product).not_to be_valid
    end

    it "price should not be blank" do
      @product.price = nil
      expect(@product).not_to be_valid
    end

    it "price should not be larger than 100000" do
      @product.price = 99999
      expect(@product).to be_valid
      @product.price = 100000
      expect(@product).to be_valid
      @product.price = 100001
      expect(@product).not_to be_valid
    end

    it "abstract should not be blank" do
      @product.abstract = ""
      expect(@product).not_to be_valid
    end

    it "abstract should not be larger than 512 words" do
      @product.abstract = "a" * 511
      expect(@product).to be_valid
      @product.abstract = "a" * 512
      expect(@product).to be_valid
      @product.abstract = "a" * 513
      expect(@product).not_to be_valid
    end

  end

end

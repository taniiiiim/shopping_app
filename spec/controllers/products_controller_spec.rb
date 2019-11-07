require 'rails_helper'

RSpec.describe ProductsController, type: :request do

  describe "GET #show" do

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

   it "returns http success" do
     get product_path(@product)
     expect(response).to have_http_status(:success)
     expect(response).to render_template "products/show"
   end
  end

end

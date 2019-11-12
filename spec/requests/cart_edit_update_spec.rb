require 'rails_helper'

RSpec.describe "carts#edit, update", type: :request do

  include CartHelper

    before do
      @gender = Gender.create!(gender: "Men's")
      @category = Category.create!(category: "coat")
      @size = Size.create!(size: "S")
      @size1 = Size.create!(size: "M")
      @product = Product.create!(name: "Coat S",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1500,
                      abstract: "A popular coat",
                      picture: "rails.png")
      @product1 = Product.create!(name: "Coat M",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size1.id,
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
                   activated: true)
      @user1 = User.create!( name:  "Example User",
                   real_name: "Example",
                   email: "example1@railstutorial.org",
                   password: "password",
                   password_confirmation: "password",
                   gender: "Male",
                   birthdate: "1993-12-01",
                   code: "241-0836",
                   address: "神奈川県横浜市旭区万騎が原64-23",
                   activated: true)
      @order1 = Order.create!(user_id: @user.id, ordered_at: Time.zone.now, ordered: true)
      @order = Order.create!(user_id: @user.id, ordered_at: Time.zone.now, ordered: false)
      @stock = Stock.create!(product_id: @product.id, stock: 1000)
      @stock1 = Stock.create!(product_id: @product1.id, stock: 1000)
    end

  describe "edit" do

    it "should redirect when not logged in" do
      get "/cart/#{@order.id}/edit"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "invalid access when logged in with wrong user" do
      log_in_as(@user1)
      get "/cart/#{@order.id}/edit"
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "invalid access without carts" do
      log_in_as(@user)
      get "/cart/#{@order.id}/edit"
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "invalid access if the cart is expired" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      count = Order.count
      @order = @user.orders.last
      @order.update_attribute(:cart_created_at, Time.zone.now - 29.minutes)
      get "/cart/#{@order.id}/edit"
      expect(count).to eq Order.count
      @order.update_attribute(:cart_created_at, Time.zone.now - 30.minutes)
      get "/cart/#{@order.id}/edit"
      expect(count).not_to eq Order.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"

      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      count = Order.count
      @order = @user.orders.last
      @order.update_attribute(:cart_created_at, Time.zone.now - 31.minutes)
      get "/cart/#{@order.id}/edit"
      expect(count).not_to eq Order.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "valid access with carts" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      @order = @user.orders.last
      get "/cart/#{@order.id}/edit"
      expect(response).to have_http_status :success
      expect(response).to render_template "cart/edit"
    end

  end

  describe "update" do

    it "should redirect when not logged in" do
      code = "241-0836"
      address = "万騎が原"
      stock = 1000
      patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
      @order.reload
      @stock.reload
      expect(@order.code).not_to eq code
      expect(@order.address).not_to eq address
      expect(@stock.stock).to eq stock
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "invalid access when logged in with wrong user" do
      log_in_as(@user1)
      code = "241-0836"
      address = "万騎が原"
      stock = 1000
      patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
      @order.reload
      @stock.reload
      expect(@order.code).not_to eq code
      expect(@order.address).not_to eq address
      expect(@stock.stock).to eq stock
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "invalid access without carts" do
      log_in_as(@user)
      code = "241-0836"
      address = "万騎が原"
      stock = 1000
      patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
      @order.reload
      @stock.reload
      expect(@order.code).not_to eq code
      expect(@order.address).not_to eq address
      expect(@stock.stock).to eq stock
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

    it "invalid access if the cart is expired" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      count = Order.count
      stock = 1000
      @order = @user.orders.last
      @order.update_attribute(:cart_created_at, Time.zone.now - 29.minutes)
      code = "241-0836"
      address = "万騎が原"
      patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
      @stock.reload
      expect(count).to eq Order.count
      expect(@stock.stock).not_to eq stock

      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      stock = 990
      count = Order.count
      @order.update_attribute(:cart_created_at, Time.zone.now - 30.minutes)
      code = "241-0836"
      address = "万騎が原"
      patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
      @stock.reload
      expect(count).not_to eq Order.count
      expect(@stock.stock).to eq stock
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"

      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      count = Order.count
      @order = @user.orders.last
      @order.update_attribute(:cart_created_at, Time.zone.now - 31.minutes)
      code = "241-0836"
      address = "万騎が原"
      patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
      @stock.reload
      expect(count).not_to eq Order.count
      expect(@stock.stock).to eq stock
    end

   it "invalid access if stock is short" do
     log_in_as(@user)
     post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
     @order = @user.orders.last
     @stock.update_attributes(stock: 1)
     @stock.reload
     code = "241-0836"
     address = "万騎が原"
     stock = 1
     patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
     @order.reload
     @stock.reload
     expect(@order.code).not_to eq code
     expect(@order.address).not_to eq address
     expect(@stock.stock).to eq stock
     follow_redirect!
     expect(flash[:danger].nil?).to be_falsey
     expect(response).to render_template "cart/show"
   end

   it "invalid access with invalid information" do
     log_in_as(@user)
     post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
     @order = @user.orders.last
     code = "241-08"
     address = ""
     stock = 1000
     patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
     @order.reload
     @stock.reload
     expect(@order.code).not_to eq code
     expect(@order.address).not_to eq address
     expect(@stock.stock).to eq stock
     assert_select "div#error_explanation"
     expect(response).to render_template "cart/edit"
   end

    it "valid access with carts" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      @order = @user.orders.last
      code = "241-0836"
      address = "万騎が原"
      stock = 1000
      patch "/cart/#{@order.id}", params: { order_id: @order.id, order: { code: code, address: address } }
      @order.reload
      @stock.reload
      expect(@order.code).to eq code
      expect(@order.address).to eq address
      expect(@stock.stock).not_to eq stock
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "orders/show"
    end

    it "reduce_stocks properly works" do
      @detail = Detail.create!(order_id: @order.id, product_id: @product.id, amount: 10)
      @detail1 = Detail.create!(order_id: @order.id, product_id: @product1.id, amount: 10)
      stock = 1000
      reduce_stocks(@order)
      @stock.reload
      @stock1.reload
      expect(@stock.stock).not_to eq stock
      expect(@stock1.stock).not_to eq stock
    end

  end
end

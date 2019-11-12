require 'rails_helper'

RSpec.describe "stocks#update", type: :request do

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
                   activated: true,
                   admin: true )
      @user1 = User.create!( name:  "Example User",
                   real_name: "Example",
                   email: "example1@railstutorial.org",
                   password: "password",
                   password_confirmation: "password",
                   gender: "Male",
                   birthdate: "1993-12-01",
                   code: "241-0836",
                   address: "神奈川県横浜市旭区万騎が原64-23",
                   activated: true,
                   admin: false )
      @stock = Stock.create!(product_id: @product.id, stock: 10000)
      @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
      @order1 = Order.create(user_id: @user1.id, ordered_at: Time.zone.now)
    end

  describe "update" do

    it "should redirect when not logged in" do
      stock = 1000
      patch stock_path(@stock), params: { stock_id: @stock.id, stock: { stock: stock } }
      @stock.reload
      expect(@stock.stock).not_to eq stock
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not update with wrong user" do
      log_in_as(@user1)
      stock = 1000
      patch stock_path(@stock), params: { stock_id: @stock.id, stock: { stock: stock } }
      @stock.reload
      expect(@stock.stock).not_to eq stock
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "stock update failure with invalid information by logged in admin user" do
      log_in_as(@user)
      stock = -1
      patch stock_path(@stock), params: { stock_id: @stock.id, stock: { stock: stock } }
      @stock.reload
      expect(@stock.stock).not_to eq stock
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "products/edit"
    end

    it "stock update failure with too much stocks by logged in admin user" do
      log_in_as(@user)
      stock = 10000000
      patch stock_path(@stock), params: { stock_id: @stock.id, stock: { stock: stock } }
      @stock.reload
      expect(@stock.stock).not_to eq stock
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "products/edit"
    end

    it "stock update success with valid information by logged in admin user" do
      log_in_as(@user)
      stock = 1000
      patch stock_path(@stock), params: { stock_id: @stock.id, stock: { stock: stock } }
      @stock.reload
      expect(@stock.stock).to eq stock
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

  end

end

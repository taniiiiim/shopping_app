require 'rails_helper'

RSpec.describe "orders#cancel, destroy", type: :request do

   include CartHelper

    before do
      ActionMailer::Base.deliveries.clear
      @gender = Gender.create!(gender: "Men's")
      @category = Category.create!(category: "coat")
      @size = Size.create!(size: "S")
      @product = Product.create!(name: "Coat S",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 2000,
                      abstract: "A special coat",
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
      @detail = Detail.create(order_id: @order.id, product_id: @product.id, amount: 10)
    end

  describe "cancel" do

    it "should redirect when not logged in" do
      get "/orders/#{@order.id}/cancel"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      get "/orders/#{@order.id}/cancel"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "valid access with logged in correct user" do
      log_in_as(@user)
      get "/orders/#{@order.id}/cancel"
      expect(response).to have_http_status :success
      expect(response).to render_template "orders/cancel"
    end

    it "should not access when the order is expired" do
      log_in_as(@user)
      @order.update_attribute(:ordered_at, Time.zone.now - 31.minute)
      get "/orders/#{@order.id}/cancel"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "orders/show"
    end

  end

  describe "destroy" do

    it "should redirect when not logged in" do
      count = Order.count
      stock = 10000
      delete order_path(@order), params: { order: { password: "password", password_confirmation: "password" } }
      @stock.reload
      expect(count).to eq Order.count
      expect(stock).to eq @stock.stock
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      count = Order.count
      stock = 10000
      delete order_path(@order), params: { order: { password: "password", password_confirmation: "password" } }
      @stock.reload
      expect(count).to eq Order.count
      expect(stock).to eq @stock.stock
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "delete failure with invalid information by logged in admin user" do
      log_in_as(@user)
      count = Order.count
      stock = 10000
      delete order_path(@order), params: { order: { password: "foo", password_confirmation: "bar" } }
      @stock.reload
      expect(count).to eq Order.count
      expect(stock).to eq @stock.stock
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "orders/cancel"
    end

    it "delete success with valid information by logged in admin user" do
      log_in_as(@user)
      count = Order.count
      stock = 10000
      delete order_path(@order), params: { order: { password: "password", password_confirmation: "password" } }
      @stock.reload
      expect(count).not_to eq Order.count
      expect(stock).not_to eq @stock.stock
      expect(ActionMailer::Base.deliveries.size).to eq 1
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "users/show"
    end

    it "should not destroy when the order is expired" do
      log_in_as(@user)
      @order.update_attribute(:ordered_at, Time.zone.now - 29.minute)
      count = Order.count
      delete order_path(@order), params: { order: { password: "password", password_confirmation: "password" } }
      expect(count).not_to eq Order.count
      @order = Order.create!(user_id: @user.id, ordered_at: Time.zone.now - 30.minute)
      count = Order.count
      delete order_path(@order), params: { order: { password: "password", password_confirmation: "password" } }
      expect(count).to eq Order.count
      @order.update_attribute(:ordered_at, Time.zone.now - 31.minute)
      count = Order.count
      delete order_path(@order), params: { order: { password: "password", password_confirmation: "password" } }
      expect(count).to eq Order.count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "orders/show"
    end

  end

end

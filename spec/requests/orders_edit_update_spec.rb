require 'rails_helper'

RSpec.describe "orders#edit, update", type: :request do

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
      @stock = Stock.create!(product_id: @product.id, stock: 100000)
      @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
      @order1 = Order.create(user_id: @user1.id, ordered_at: Time.zone.now)
    end

  describe "edit" do

    it "should redirect when not logged in" do
      get edit_order_path(@order)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      get edit_order_path(@order)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "valid access with logged in correct user" do
      log_in_as(@user)
      get edit_order_path(@order)
      expect(response).to have_http_status :success
      expect(response).to render_template "orders/edit"
    end

    it "should not access when an order is expired" do
      log_in_as(@user)
      @order.update_attribute(:ordered_at, Time.zone.now - 31.minute)
      get edit_order_path(@order)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "orders/show"
    end

  end

  describe "update" do

    it "should redirect when not logged in" do
      code = "241-0836"
      address = "神奈川県横浜市旭区万騎が原64-23"
      patch order_path(@order), params: { order: { code: code, address: address } }
      @order.reload
      expect(@order.code).not_to eq code
      expect(@order.address).not_to eq address
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      code = "241-0836"
      address = "神奈川県横浜市旭区万騎が原64-23"
      patch order_path(@order), params: { order: { code: code, address: address } }
      @order.reload
      expect(@order.code).not_to eq code
      expect(@order.address).not_to eq address
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "update failure with invalid information by logged in correct user" do
      log_in_as(@user)
      code = "241-083"
      address = ""
      patch order_path(@order), params: { order: { code: code, address: address } }
      @order.reload
      expect(@order.code).not_to eq code
      expect(@order.address).not_to eq address
      assert_select "div#error_explanation"
      expect(response).to render_template "orders/edit"
    end

    it "update success with valid information by logged in correct user" do
      log_in_as(@user)
      code = "241-0836"
      address = "神奈川県横浜市旭区万騎が原64-23"
      patch order_path(@order), params: { order: { code: code, address: address } }
      @order.reload
      expect(@order.code).to eq code
      expect(@order.address).to eq address
      expect(ActionMailer::Base.deliveries.size).to eq 1
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "orders/show"
    end

    it "should not access when an order is expired" do
      log_in_as(@user)
      @order.update_attribute(:ordered_at, Time.zone.now - 31.minute)
      code = "241-0836"
      address = "神奈川県横浜市旭区万騎が原64-23"
      patch order_path(@order), params: { order: { code: code, address: address } }
      @order.reload
      expect(@order.code).not_to eq code
      expect(@order.address).not_to eq address
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "orders/show"
    end

  end

end

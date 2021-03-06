require 'rails_helper'

RSpec.describe "products#new, create", type: :request do

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
      @stock = Stock.create!(product_id: @product.id, stock: 100000)
      @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
      @order1 = Order.create(user_id: @user1.id, ordered_at: Time.zone.now)
      @file = fixture_file_upload("612ccaeb6b1f0d25324f9a290f31d054_s.jpg", true)
    end

  describe "new" do

    it "should redirect when not logged in" do
      get new_product_path
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      get new_product_path
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "valid access with logged in admin user" do
      log_in_as(@user)
      get new_product_path
      expect(response).to have_http_status :success
      expect(response).to render_template "products/new"
    end

  end

  describe "create" do

    it "should redirect when not logged in" do
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat M",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1500,
                      abstract: "A popular coat",
                      picture: @file } }
      expect(count).to eq Product.count
      expect(counts).to eq Stock.count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat M",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1500,
                      abstract: "A popular coat",
                      picture: @file } }
      expect(count).to eq Product.count
      expect(counts).to eq Stock.count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "product addition failure with invalid information by logged in admin user" do
      log_in_as(@user)
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat S",
                      gender_id: nil,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1000000000,
                      abstract: "",
                      picture: @file } }
      expect(count).to eq Product.count
      expect(counts).to eq Stock.count
      assert_select "div#error_explanation"
      expect(response).to render_template "products/new"
    end

    it "product addition success with valid information by logged in admin user" do
      log_in_as(@user)
      count = Product.count
      counts = Stock.count
      post products_path, params: { product: { name: "Coat M",
                      gender_id: @gender.id,
                      category_id: @category.id,
                      size_id: @size.id,
                      price: 1500,
                      abstract: "A popular coat",
                      picture: @file } }
      expect(count).not_to eq Product.count
      expect(counts).not_to eq Stock.count
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

  end

end

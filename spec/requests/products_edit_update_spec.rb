require 'rails_helper'

RSpec.describe "products#edit, update", type: :request do

    before do
      @gender = Gender.create!(gender: "Men's")
      @gender1 = Gender.create!(gender: "Lady's")
      @category = Category.create!(category: "coat")
      @category1 = Category.create!(category: "coat2")
      @size = Size.create!(size: "S")
      @size1 = Size.create!(size: "M")
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
      get edit_product_path(@product)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      get edit_product_path(@product)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "valid access with logged in admin user" do
      log_in_as(@user)
      get edit_product_path(@product)
      expect(response).to have_http_status :success
      expect(response).to render_template "products/edit"
    end

  end

  describe "update" do

    it "should redirect when not logged in" do
      name = "Coat M"
      gender_id = 2
      category_id = 2
      size_id = 2
      price = 1500
      abstract = "A popular coat"
      patch product_path(@product), params: { product: { name: name,
                      gender_id: gender_id,
                      category_id: category_id,
                      size_id: size_id,
                      price: price,
                      abstract: abstract,
                      picture: "rails.png" } }
      @product.reload
      expect(@product.name).not_to eq name
      expect(@product.gender_id).not_to eq gender_id
      expect(@product.category_id).not_to eq category_id
      expect(@product.size_id).not_to eq size_id
      expect(@product.price).not_to eq price
      expect(@product.abstract).not_to eq abstract
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      name = "Coat M"
      gender_id = 2
      category_id = 2
      size_id = 2
      price = 1500
      abstract = "A popular coat"
      patch product_path(@product), params: { product: { name: name,
                      gender_id: gender_id,
                      category_id: category_id,
                      size_id: size_id,
                      price: price,
                      abstract: abstract,
                      picture: "rails.png" } }
      @product.reload
      expect(@product.name).not_to eq name
      expect(@product.gender_id).not_to eq gender_id
      expect(@product.category_id).not_to eq category_id
      expect(@product.size_id).not_to eq size_id
      expect(@product.price).not_to eq price
      expect(@product.abstract).not_to eq abstract
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "product addition failure with invalid information by logged in admin user" do
      log_in_as(@user)
      name = ""
      gender_id = 0
      category_id = 0
      size_id = 0
      price = 1000001
      abstract = ""
      patch product_path(@product), params: { product: { name: name,
                      gender_id: gender_id,
                      category_id: category_id,
                      size_id: size_id,
                      price: price,
                      abstract: abstract,
                      picture: "rails.png" } }
      @product.reload
      expect(@product.name).not_to eq name
      expect(@product.gender_id).not_to eq gender_id
      expect(@product.category_id).not_to eq category_id
      expect(@product.size_id).not_to eq size_id
      expect(@product.price).not_to eq price
      expect(@product.abstract).not_to eq abstract
      assert_select "div#error_explanation"
      expect(response).to render_template "products/edit"
    end

    it "product addition success with valid information by logged in admin user" do
      log_in_as(@user)
      name = "Coat M"
      gender_id = @gender1.id
      category_id = @category1.id
      size_id = @size1.id
      price = 1500
      abstract = "A popular coat"
      patch product_path(@product), params: { product: { name: name,
                      gender_id: gender_id,
                      category_id: category_id,
                      size_id: size_id,
                      price: price,
                      abstract: abstract,
                      picture: "rails.png" } }
      @product.reload
      expect(@product.name).to eq name
      expect(@product.gender_id).to eq gender_id
      expect(@product.category_id).to eq category_id
      expect(@product.size_id).to eq size_id
      expect(@product.price).to eq price
      expect(@product.abstract).to eq abstract
      follow_redirect!
      expect(response).to have_http_status :success
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

  end

end

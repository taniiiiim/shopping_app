require 'rails_helper'

RSpec.describe "carts#create", type: :request do

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
      @order1 = Order.create!(user_id: @user.id, ordered_at: Time.zone.now, ordered: true)
      @stock = Stock.create!(product_id: @product.id, stock: 1000)
      @stock1 = Stock.create!(product_id: @product1.id, stock: 1000)
    end

  describe "create" do

    it "should redirect when not logged in" do
      counto = Order.count
      countd = Detail.count
      post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
      expect(counto).to eq Order.count
      expect(countd).to eq Detail.count
      follow_redirect!
      assert_select "div.alert"
      expect(any_carts?).to be_falsey
      expect(response).to render_template "sessions/new"
    end

    it "invalid access with invalid amount" do
      log_in_as(@user)
      counto = Order.count
      countd = Detail.count
      post "/cart", params: { product_id: @product.id, detail: { amount: 100001 } }
      expect(counto).to eq Order.count
      expect(countd).to eq Detail.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(any_carts?).to be_falsey
      expect(response).to render_template "products/show"
    end

    it "order cretation failure when stock is short" do
      log_in_as(@user)
      counto = Order.count
      countd = Detail.count
      post "/cart", params: { product_id: @product.id, detail: { amount: 5000 } }
      expect(counto).to eq Order.count
      expect(countd).to eq Detail.count
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(any_carts?).to be_falsey
      expect(response).to render_template "products/show"
    end

    it "both order and details cretation conducted when orders yet confirmed not present" do
      log_in_as(@user)
      counto = Order.count
      countd = Detail.count
      post "/cart", params: { product_id: @product.id, detail: { amount: 100 } }
      expect(counto).not_to eq Order.count
      expect(countd).not_to eq Detail.count
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

    it "only details cretation conducted when orders yet confirmed present and details of the product not present" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 100 } }
      counto = Order.count
      countd = Detail.count
      post "/cart", params: { product_id: @product1.id, detail: { amount: 100 } }
      expect(counto).to eq Order.count
      expect(countd).not_to eq Detail.count
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

    it "only details update conducted when orders yet confirmed present and details of the product not present" do
      log_in_as(@user)
      post "/cart", params: { product_id: @product.id, detail: { amount: 100 } }
      @detail = Detail.find_by(product_id: @product.id)
      counto = Order.count
      countd = Detail.count
      amount = 150
      post "/cart", params: { product_id: @product.id, detail: { amount: amount } }
      @detail.reload
      expect(counto).to eq Order.count
      expect(countd).to eq Detail.count
      expect(@detail.amount).to eq amount
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "products/show"
    end

  end
end

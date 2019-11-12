require 'rails_helper'

RSpec.describe "carts#edit, update", type: :request do

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

    describe "destroy" do

      it "should redirect when not logged in" do
        delete "/cart/#{@order.id}"
        follow_redirect!
        assert_select "div.alert"
        expect(response).to render_template "sessions/new"
      end

      it "invalid access when logged in with wrong user" do
        log_in_as(@user1)
        delete "/cart/#{@order.id}"
        follow_redirect!
        expect(flash[:danger].nil?).to be_falsey
        expect(response).to render_template "static_pages/home"
      end

      it "invalid access without carts" do
        log_in_as(@user)
        delete "/cart/#{@order.id}"
        follow_redirect!
        expect(flash[:danger].nil?).to be_falsey
        expect(response).to render_template "static_pages/home"
      end

      it "invalid access if the cart is expired" do
        log_in_as(@user)
        post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
        count = Order.count
        @order = @user.orders.last
        @order.update_attribute(:cart_created_at, Time.zone.now - 31.minutes)
        delete "/cart/#{@order.id}"
        expect(count).not_to eq Order.count
        follow_redirect!
        expect(flash[:danger].nil?).to be_falsey
        expect(response).to render_template "static_pages/home"
      end

      it "valid access with carts" do
        log_in_as(@user)
        post "/cart", params: { product_id: @product.id, detail: { amount: 10 } }
        @order = @user.orders.last
        count = Order.count
        delete "/cart/#{@order.id}"
        expect(count).not_to eq Order.count
        follow_redirect!
        expect(flash[:success].nil?).to be_falsey
        expect(response).to render_template "static_pages/home"
      end

    end

end

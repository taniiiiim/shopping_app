require 'rails_helper'

RSpec.describe Order, type: :model do

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
    @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
    @detail = Detail.create!(order_id: @order.id, product_id: @product.id, amount: 10)
  end

  it "valid order" do
    expect(@order).to be_valid
  end

  it "user_id should not be blank" do
    @order.user_id = nil
    expect(@order).not_to be_valid
  end

  it "code can be nil" do
    @order.code = nil
    expect(@order).to be_valid
  end

  it "code should not be blank" do
    @order.code = ""
    expect(@order).not_to be_valid
  end

  it "invalid order with invalid code" do

    @order.code = "241-083"
    expect(@order).not_to be_valid
    @order.code = "241-0836"
    expect(@order).to be_valid
    @order.code = "241-08366"
    expect(@order).not_to be_valid

    invalid_codes = %w[24108366 241-08-3 -2410836 2-410836 24-10836
                      2410-836 24108-36 241083-6 2410836-]
    invalid_codes.each do |invalid_code|
      @order.code = invalid_code
      assert !@order.valid?, "#{invalid_code.inspect} should be invalid"
    end
  end

  it "address can be nil" do
    @order.address = nil
    expect(@order).to be_valid
  end

  it "address should not be blank" do
    @order.address = ""
    expect(@order).not_to be_valid
  end

  it "address should not be longer than 255" do
    @order.address = ""
    expect(@order).not_to be_valid
    @order.address = "a" * 254
    expect(@order).to be_valid
    @order.address = "a" * 255
    expect(@order).to be_valid
    @order.address = "a" * 256
    expect(@order).not_to be_valid
  end

  it "details are destroyed if a related order is destroyed" do
    count = Detail.count
    @order.destroy
    expect(count).not_to eq Detail.count
  end

end

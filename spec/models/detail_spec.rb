require 'rails_helper'

RSpec.describe Detail, type: :model do

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

  it "valid detail" do
    expect(@detail).to be_valid
  end

  it "invaild detail without order_id" do
    @detail.order_id = nil
    expect(@detail).not_to be_valid
  end

  it "invaild detail without product_id" do
    @detail.product_id = nil
    expect(@detail).not_to be_valid
  end

  it "invaild detail without amount" do
    @detail.amount = nil
    expect(@detail).not_to be_valid
  end

  it "amount should not be negative" do
    @detail.amount = -1
    expect(@detail).not_to be_valid
    @detail.amount = 0
    expect(@detail).to be_valid
    @detail.amount = 1
    expect(@detail).to be_valid
  end

  it "amount should not be larger than 100000" do
    @detail.amount = 99999
    expect(@detail).to be_valid
    @detail.amount = 100000
    expect(@detail).to be_valid
    @detail.amount = 100001
    expect(@detail).not_to be_valid
  end

end

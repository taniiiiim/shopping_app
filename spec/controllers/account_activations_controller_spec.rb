require 'rails_helper'

RSpec.describe AccountActivationsController, type: :request do

  before do
    ActionMailer::Base.deliveries.clear
    post users_path, params: { user: { name: "Example User",
                 real_name: "Example",
                 email: "example@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 gender: "Male",
                 birthdate: "1993-12-01",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23" } }
    @user = assigns(:user)
    @order = Order.create!(user_id: @user.id, ordered_at: Time.zone.now)
    follow_redirect!
  end

  it "activation success with valid token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    @user.reload
    expect(@user.activated).to be_truthy
    expect(is_logged_in?).to be_truthy
    follow_redirect!
    expect(response).to render_template "users/show"
  end

  it "activation failure with invalid token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    @user.reload
    expect(@user.activated).to be_falsey
    expect(is_logged_in?).to be_falsey
  end

  it "activation failure with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: "invalid email")
    @user.reload
    expect(@user.activated).to be_falsey
    expect(is_logged_in?).to be_falsey
  end

end

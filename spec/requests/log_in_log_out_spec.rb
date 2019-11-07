require 'rails_helper'

RSpec.describe "log in / log out", type: :request do

  before do
    post signup_path, params: { user: {name:  "Example User",
                 real_name: "Example",
                 email: "example@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 gender: "Male",
                 birthdate: "1993-12-01",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23"} }
    @user = User.first
    @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
  end


  it "login failure when not activated" do
    log_in_as(@user)
    expect(is_logged_in?).to be_falsey
    expect(flash[:warning].nil?).to be_falsey
    follow_redirect!
    expect(response).to render_template "sessions/new"
  end

  it "invalid login information" do
    @user.update_attribute(:activated, true)
    post login_path, params: { session: { email:    "user@invalid",
                                      password: "" } }
    assert_select "div.alert"
    expect(response).to render_template "sessions/new"
  end

  it "valid login information" do
    @user.update_attribute(:activated, true)
    log_in_as(@user)
    expect(is_logged_in?).to be_truthy
    follow_redirect!
    expect(response).to render_template "users/show"
  end

  it "logout successful" do
    @user.update_attribute(:activated, true)
    log_in_as(@user)
    delete logout_path
    expect(is_logged_in?).to be_falsey
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

  it "does not logout if logged out" do
    delete logout_path
    expect(is_logged_in?).to be_falsey
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

  it "login with remembering" do
    @user.update_attribute(:activated, true)
    log_in_as(@user, remember_me: '1')
    expect(cookies['remember_token'].empty?).to be_falsey
  end

  it "login with remembering" do
    @user.update_attribute(:activated, true)
    log_in_as(@user, remember_me: '1')
    delete logout_path
    log_in_as(@user, remember_me: '0')
    expect(cookies['remember_token'].empty?).to be_truthy
  end

  it "login with cookies" do
    @user.update_attribute(:activated, true)
    log_in_as(@user, remember_me: '1')
    session[:user_id] = nil
    get root_path
    assert_select "a[href=?]", logout_path
  end

  it "login fails with invalid cookies" do
    @user.update_attribute(:activated, true)
    log_in_as(@user, remember_me: '1')
    session[:user_id] = nil
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    redirect_to root_path
    assert_select "a[href=?]", logout_path, count: 0
  end

  it "friendly-forwarding" do
    @user.update_attribute(:activated, true)
    get user_path(@user)
    log_in_as(@user)
    follow_redirect!
    expect(response).to render_template "users/show"
  end

end

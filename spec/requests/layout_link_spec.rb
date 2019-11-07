require 'rails_helper'

RSpec.describe "layout links", type: :request do

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
    @user.update_attribute(:activated, true)
    @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
  end

  it "layout links when not logged in" do
    get root_url
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
  end

  it "layout links when logged in" do
    log_in_as(@user)
    get root_url
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path, count: 2
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", "/cart/#{Order.first.id}"
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", "/users/#{@user.id}/exit"
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", login_path, count: 0
  end

end

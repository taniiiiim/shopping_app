require 'rails_helper'

RSpec.describe "users#show", type: :request do

  before do
    @user = User.create!( name:  "Example User",
                 real_name: "Example",
                 email: "example@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 gender: "Male",
                 birthdate: "1993-12-01",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23",
                 activated: true )
    @user1 = User.create!( name:  "Example User",
                 real_name: "Example",
                 email: "example1@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 gender: "Male",
                 birthdate: "1993-12-01",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23",
                 activated: true )
    @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
  end

  it "should redirect when not logged in" do
    get user_path(@user)
    follow_redirect!
    assert_select "div.alert"
    expect(response).to render_template "sessions/new"
  end

  it "should not access with wrong user" do
    log_in_as(@user)
    get user_path(@user1)
    follow_redirect!
    assert_select "div.alert"
    expect(response).to render_template "static_pages/home"
  end

  it "valid access" do
    log_in_as(@user)
    get user_path(@user)
    expect(response).to have_http_status :success
    expect(response).to render_template "users/show"
  end

end

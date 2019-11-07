require 'rails_helper'

RSpec.describe "users#exit, destroy", type: :request do

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

  describe "exit" do

    it "should redirect when not logged in" do
      get "/users/#{@user.id}/exit"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user)
      get "/users/#{@user1.id}/exit"
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "valid access" do
      log_in_as(@user)
      get "/users/#{@user.id}/exit"
      expect(response).to have_http_status :success
      expect(response).to render_template "users/exit"
    end

  end

  describe "destroy" do

    it "should redirect when not logged in" do
      delete user_path(@user), params: { user: { emial: "", password: "", password_confirmation: "" } }
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user1)
      count = User.count
      delete user_path(@user), params: { user: { email: "example@railstutorial.org",
                    password: "password",
                    password_confirmation: "password" } }
      expect(User.count).to eq count
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "delete failure with invalid information" do
      log_in_as(@user)
      count = User.count
      delete user_path(@user), params: { user: { email: "", password: "", password_confirmation: "" } }
      expect(User.count).to eq count
      assert_select "div.alert"
      expect(response).to render_template "users/exit"
    end

    it "delete success with valid information" do
      log_in_as(@user)
      count = User.count
      delete user_path(@user), params: { user: { email: "example@railstutorial.org",
                    password: "password",
                    password_confirmation: "password" } }
      expect(User.count).not_to eq count
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

  end

end

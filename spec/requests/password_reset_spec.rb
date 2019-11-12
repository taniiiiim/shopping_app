require 'rails_helper'

RSpec.describe PasswordResetsController, type: :request do

  before do
    ActionMailer::Base.deliveries.clear
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
    @order = Order.create!(user_id: @user.id, ordered_at: Time.zone.now)
  end

  describe "new" do

    it "successful access to forgot password" do
      get new_password_reset_path
      expect(response).to have_http_status :success
      expect(response).to render_template "password_resets/new"
    end

  end

  describe "create" do

    it "no email sent to unknown address" do
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(@user.reset_digest).to eq @user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 0
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "password_resets/new"
    end

    it "email goes to known address" do
      post password_resets_path, params: { password_reset: { email: "example@railstutorial.org" } }
      expect(@user.reset_digest).not_to eq @user.reload.reset_digest
      expect(ActionMailer::Base.deliveries.size).to eq 1
      follow_redirect!
      expect(flash[:info].nil?).to be_falsey
      expect(response).to render_template "static_pages/home"
    end

  end

  describe "edit" do

    before do
      post password_resets_path, params: { password_reset: { email: "example@railstutorial.org" } }
      @user = assigns(:user)
    end

    it "valid access" do
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to have_http_status :success
      expect(response).to render_template "password_resets/edit"
      assert_select "input[name=email][type=hidden][value=?]", @user.email
    end

    it "invalid access by inactivated user" do
      @user.update_attributes(activated: false)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      follow_redirect!
      expect(response).to have_http_status :success
      expect(response).to render_template "static_pages/home"
    end

    it "invalid access with wrong token" do
      get edit_password_reset_path("wrong_token", email: @user.email)
      follow_redirect!
      expect(response).to have_http_status :success
      expect(response).to render_template "static_pages/home"
    end

    it "invalid access with invalid email" do
      get edit_password_reset_path(@user.reset_token, email: "wrong_email")
      follow_redirect!
      expect(response).to have_http_status :success
      expect(response).to render_template "static_pages/home"
    end

  end

  describe "update" do

    before do
      post password_resets_path, params: { password_reset: { email: "example@railstutorial.org" } }
      @user = assigns(:user)
    end

    it "invalid update with blank password" do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
         user: { password: "", password_confirmation: "" } }
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "password_resets/edit"
    end

    it "invalid update with invalid password combination" do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
         user: { password: "aaaaaa", password_confirmation: "bbbbbb" } }
      expect(flash[:danger].nil?).to be_falsey
      expect(response).to render_template "password_resets/edit"
    end

    it "invalid update if the token is expired" do
      @user.update_attributes(reset_sent_at: Time.zone.now - 121.minutes)
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
         user: { password: "Treasure1131", password_confirmation: "Treasure1131" } }
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(is_logged_in?).to be_falsey
      expect(response).to render_template "password_resets/new"
      @user.update_attributes(reset_sent_at: Time.zone.now - 120.minutes)
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
      user: { password: "Treasure1131", password_confirmation: "Treasure1131" } }
      follow_redirect!
      expect(flash[:danger].nil?).to be_falsey
      expect(is_logged_in?).to be_falsey
      expect(response).to render_template "password_resets/new"
      @user.update_attributes(reset_sent_at: Time.zone.now - 119.minutes)
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
         user: { password: "Treasure1131", password_confirmation: "Treasure1131" } }
      expect(flash[:success].nil?).to be_falsey
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(response).to render_template "users/show"
    end

    it "valid update" do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
         user: { password: "Treasure1131", password_confirmation: "Treasure1131" } }
      expect(flash[:success].nil?).to be_falsey
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(response).to render_template "users/show"
    end

  end

end

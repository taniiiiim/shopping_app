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
                 address: "神奈川県横浜市旭区万騎が原64-23")
  end

  it "successful access to forgot password" do
    get new_password_reset_path
    expect(response).to have_http_status :success
    expect(response).to render_template "password_resets/new"
  end

  it "no email sent to unknown address" do
    post password_resets_path, params: { password_reset: { email: "" } }
    expect(flash[:danger].nil?).to be_falsey
    expect(response).to render_template "password_resets/new"
  end

  it "email goes to known address" do
    post password_resets_path, params: { password_reset: { email: "example@railstutorial.org" } }
    expect(ActionMailer::Base.deliveries.size).to eq 1
    follow_redirect!
    expect(flash[:info].nil?).to be_falsey
    expect(response).to render_template "static_pages/home"
  end

  it "invalid access to password reset form with invalid email" do
    post password_resets_path, params: { password_reset: { email: "example@railstutorial.org" } }
    user = assigns(:user)
    get edit_password_reset_path(user.activation_token, email: "")
    follow_redirect!
    expect(response).to render_template "static_pages/home"
  end

end

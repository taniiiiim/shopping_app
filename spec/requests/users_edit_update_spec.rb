require 'rails_helper'

RSpec.describe "users#edit, update", type: :request do

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
                 birthdate: "1993-12-02",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23",
                 activated: true )
    @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
  end

  describe "edit" do

    it "should redirect when not logged in" do
      get edit_user_path(@user)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user)
      get edit_user_path(@user1)
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "valid access" do
      log_in_as(@user)
      get edit_user_path(@user)
      expect(response).to have_http_status :success
      expect(response).to render_template "users/edit"
    end

  end

  describe "update" do

    it "should redirect when not logged in" do
      name = "Example1 User"
      real_name = "Example1"
      email = "example0@railstutorial.org"
      gender = "Female"
      birthdate = "1993-12-02"
      code = "241-0837"
      address = "神奈川県横浜市旭区万騎が原64-25"
      patch user_path(@user), params: { user: { name:  name,
                   real_name: real_name,
                   email: email,
                   gender: gender,
                   birthdate: birthdate,
                   code: code,
                   address: address } }
      @user.reload
      expect(name).not_to eq @user.name
      expect(real_name).not_to eq @user.real_name
      expect(email).not_to eq @user.email
      expect(gender).not_to eq @user.gender
      expect(birthdate).not_to eq @user.birthdate
      expect(code).not_to eq @user.code
      expect(address).not_to eq @user.address
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "sessions/new"
    end

    it "should not access with wrong user" do
      log_in_as(@user)
      name = "Example1 User"
      real_name = "Example1"
      email = "example0@railstutorial.org"
      gender = "Female"
      birthdate = "1993-12-02"
      code = "241-0837"
      address = "神奈川県横浜市旭区万騎が原64-25"
      patch user_path(@user1), params: { user: { name:  name,
                   real_name: real_name,
                   email: email,
                   gender: gender,
                   birthdate: birthdate,
                   code: code,
                   address: address } }
      @user1.reload
      expect(name).not_to eq @user1.name
      expect(real_name).not_to eq @user1.real_name
      expect(email).not_to eq @user1.email
      expect(gender).not_to eq @user1.gender
      expect(birthdate).not_to eq @user1.birthdate
      expect(code).not_to eq @user1.code
      expect(address).not_to eq @user1.address
      follow_redirect!
      assert_select "div.alert"
      expect(response).to render_template "static_pages/home"
    end

    it "update failure with invalid information" do
      log_in_as(@user)
      name = ""
      real_name = ""
      email = "example1@railstutorial.org"
      gender = ""
      birthdate = ""
      code = ""
      address = ""
      patch user_path(@user), params: { user: { name:  name,
                   real_name: real_name,
                   email: email,
                   gender: gender,
                   birthdate: birthdate,
                   code: code,
                   address: address } }
      @user.reload
      expect(name).not_to eq @user.name
      expect(real_name).not_to eq @user.real_name
      expect(email).not_to eq @user.email
      expect(gender).not_to eq @user.gender
      expect(birthdate).not_to eq @user.birthdate
      expect(code).not_to eq @user.code
      expect(address).not_to eq @user.address
      assert_select "div#error_explanation"
      expect(response).to render_template "users/edit"
    end

    it "update success with valid information" do
      log_in_as(@user)
      name = "Example1 User"
      real_name = "Example1"
      email = "example0@railstutorial.org"
      gender = "Female"
      birthdate = "1993-12-02"
      code = "241-0837"
      address = "神奈川県横浜市旭区万騎が原64-25"
      patch user_path(@user), params: { user: { name:  name,
                   real_name: real_name,
                   email: email,
                   gender: gender,
                   birthdate: birthdate,
                   code: code,
                   address: address } }
      @user.reload
      expect(name).to eq @user.name
      expect(real_name).to eq @user.real_name
      expect(email).to eq @user.email
      expect(gender).to eq @user.gender
      expect(@user1.birthdate).to eq @user.birthdate
      expect(code).to eq @user.code
      expect(address).to eq @user.address
      follow_redirect!
      expect(flash[:success].nil?).to be_falsey
      expect(response).to render_template "users/show"
    end

  end

end

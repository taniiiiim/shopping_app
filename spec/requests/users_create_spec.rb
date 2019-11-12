require 'rails_helper'

RSpec.describe "user functions", type: :request do

  before do
    ActionMailer::Base.deliveries.clear
  end

  it "registration failure with invalid information" do
    count = User.count
    post signup_path, params: { user: {name:  "",
                 real_name: "",
                 email: "example@invalid",
                 password: "bar",
                 password_confirmation: "foo",
                 gender: "",
                 birthdate: "1993",
                 code: "241-083",
                 address: "" } }
    expect(count).to eq User.count
    assert_select "div#error_explanation"
    expect(response).to render_template "users/new"
  end

  it "registration success with valid information" do
    count = User.count
    post signup_path, params: { user: {name:  "Example User",
                 real_name: "Example",
                 email: "example@railstutorial.org",
                 password: "Treasure1131",
                 password_confirmation: "Treasure1131",
                 gender: "Male",
                 birthdate: "1993-12-01",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23"} }
    expect(count).not_to eq User.count
    expect(ActionMailer::Base.deliveries.size).to eq 1
    follow_redirect!
    expect(response).to render_template "static_pages/home"
    assert_select "div.alert"
  end

end

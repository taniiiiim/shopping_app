require 'rails_helper'

RSpec.describe UsersController, type: :request do

  before do
    @user = User.create!(name:  "Example User",
                 real_name: "Example",
                 email: "example@railstutorial.org",
                 password: "Treasure1131",
                 password_confirmation: "Treasure1131",
                 gender: "Male",
                 birthdate: "1993-12-01",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23")
  end

  describe "GET #new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template "users/new"
    end
  end

end

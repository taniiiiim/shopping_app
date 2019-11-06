require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do

  describe "GET #home" do
    it "returns http success" do
      get root_path
      assert_select "title", "Taniiiiim Shopping App"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get help_path
      assert_select "title", "Help | Taniiiiim Shopping App"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get about_path
      assert_select "title", "About | Taniiiiim Shopping App"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #contact" do
    it "returns http success" do
      get contact_path
      assert_select "title", "Contact | Taniiiiim Shopping App"
      expect(response).to have_http_status(:success)
    end
  end

end

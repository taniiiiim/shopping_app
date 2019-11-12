require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  before do
    @user = User.create!( name:  "Example User",
                 real_name: "Example",
                 email: "example@railstutorial.org",
                 password: "password",
                 password_confirmation: "password",
                 gender: "Male",
                 birthdate: "1993-12-01",
                 code: "241-0836",
                 address: "神奈川県横浜市旭区万騎が原64-23")
    @user.activation_token = User.new_token
    @user.reset_token = User.new_token

  end

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
      expect(mail.body.encoded).to match(@user.name)
      expect(mail.body.encoded).to match(@user.activation_token)
      expect(mail.body.encoded).to match(CGI.escape(@user.email))
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("To reset your password click the link below")
      expect(mail.body.encoded).to match(@user.reset_token)
      expect(mail.body.encoded).to match(CGI.escape(@user.email))
    end
  end

end

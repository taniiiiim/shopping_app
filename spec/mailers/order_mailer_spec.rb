require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do

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
    @order = Order.create(user_id: @user.id, ordered_at: Time.zone.now)
  end

  describe "order_create" do
    let(:mail) { OrderMailer.order_create(@order) }

    it "renders the headers" do
      expect(mail.subject).to eq("Thank you for the order!")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
      expect(mail.body.encoded).to match(@user.name)
      expect(mail.body.encoded).to match("Thank you for shopping at Taniiiiim Shopping App! Click on the link below to check your order")
      expect(mail.body.encoded).to match("Order")
    end
  end

  describe "order_update" do
    let(:mail) { OrderMailer.order_update(@order) }

    it "renders the headers" do
      expect(mail.subject).to eq("Order destination changed!")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
      expect(mail.body.encoded).to match(@user.name)
      expect(mail.body.encoded).to match("The destination of your order have been changed! Please check the details on the link below.")
      expect(mail.body.encoded).to match("Order")
    end
  end

  describe "order_delete" do
    let(:mail) { OrderMailer.order_delete(@order) }

    it "renders the headers" do
      expect(mail.subject).to eq("Order canceled!")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
      expect(mail.body.encoded).to match(@user.name)
      expect(mail.body.encoded).to match("Your order was canceled. Please check your order history.")
    end
  end

end

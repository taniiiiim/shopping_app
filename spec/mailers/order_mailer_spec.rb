require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  describe "order_create" do
    let(:mail) { OrderMailer.order_create }

    it "renders the headers" do
      expect(mail.subject).to eq("Order create")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "order_update" do
    let(:mail) { OrderMailer.order_update }

    it "renders the headers" do
      expect(mail.subject).to eq("Order update")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "order_delete" do
    let(:mail) { OrderMailer.order_delete }

    it "renders the headers" do
      expect(mail.subject).to eq("Order delete")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end

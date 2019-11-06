require 'rails_helper'

RSpec.describe User, type: :model do

  describe "valid user definition" do

    before do
      @user = User.new(name:  "Example User",
                   real_name: "Example",
                   email: "example@railstutorial.org",
                   password: "Treasure1131",
                   password_confirmation: "Treasure1131",
                   gender: "Male",
                   birthdate: "1993-12-01",
                   code: "241-0836",
                   address: "神奈川県横浜市旭区万騎が原64-23")
    end

    it "valid user with valid information" do
      expect(@user).to be_valid
    end

    it "invalid user with invalid name" do
      @user.name = ""
      expect(@user).not_to be_valid
      @user.name = "a" * 49
      expect(@user).to be_valid
      @user.name = "a" * 50
      expect(@user).to be_valid
      @user.name = "a" * 51
      expect(@user).not_to be_valid
    end

    it "invalid user with invalid real_name" do
      @user.real_name = ""
      expect(@user).not_to be_valid
      @user.real_name = "a" * 49
      expect(@user).to be_valid
      @user.real_name = "a" * 50
      expect(@user).to be_valid
      @user.real_name = "a" * 51
      expect(@user).not_to be_valid
    end

    it "invalid user with invalid email" do
      @user.save
      @user1 = User.new(name:  "Example User",
                   real_name: "Example",
                   email: "Example@railstutorial.org",
                   password: "Treasure1131",
                   password_confirmation: "Treasure1131",
                   gender: "Male",
                   birthdate: "1993-12-01",
                   code: "241-0836",
                   address: "神奈川県横浜市旭区万騎が原64-23")
      expect(@user1).not_to be_valid

      @user.email = ""
      expect(@user).not_to be_valid

      @user.email = "a" * 246 + "@foo.org"
      expect(@user).to be_valid
      @user.email = "a" * 247 + "@foo.org"
      expect(@user).to be_valid
      @user.email = "a" * 248 + "@foo.org"
      expect(@user).not_to be_valid

      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                     first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        assert @user.valid?, "#{valid_address.inspect} should be valid"
      end

      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                       foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        assert !@user.valid?, "#{invalid_address.inspect} should be invalid"
      end
    end

    it "invalid user with invalid password" do
      @user.password = @user.password_confirmation = ""
      expect(@user).not_to be_valid
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).not_to be_valid
      @user.password = @user.password_confirmation = "a" * 6
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 7
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 19
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 20
      expect(@user).to be_valid
      @user.password = @user.password_confirmation = "a" * 21
      expect(@user).not_to be_valid
    end

    it "invalid user with invalid gender" do
      @user.gender = ""
      expect(@user).not_to be_valid
      @user.gender = "a" * 19
      expect(@user).to be_valid
      @user.gender = "a" * 20
      expect(@user).to be_valid
      @user.gender = "a" * 21
      expect(@user).not_to be_valid
    end

    it "invalid user with invalid code" do
      @user.code = ""
      expect(@user).not_to be_valid

      @user.code = "241-083"
      expect(@user).not_to be_valid
      @user.code = "241-0836"
      expect(@user).to be_valid
      @user.code = "241-08366"
      expect(@user).not_to be_valid

      invalid_codes = %w[24108366 241-08-3 -2410836 2-410836 24-10836
                        2410-836 24108-36 241083-6 2410836-]
      invalid_codes.each do |invalid_code|
        @user.code = invalid_code
        assert !@user.valid?, "#{invalid_code.inspect} should be invalid"
      end
    end

    it "invalid user with invalid address" do
      @user.address = ""
      expect(@user).not_to be_valid
      @user.address = "a" * 254
      expect(@user).to be_valid
      @user.address = "a" * 255
      expect(@user).to be_valid
      @user.address = "a" * 256
      expect(@user).not_to be_valid
    end

  end

end

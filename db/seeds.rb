# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
Gender.create!(gender: "Men's")
Gender.create!(gender: "Lady's")
Gender.create!(gender: "Unisex")
Category.create!(category: "coat")
Category.create!(category: "parker")
Category.create!(category: "shirt")
Category.create!(category: "T-shirt")
Category.create!(category: "pant")
Category.create!(category: "underware")
Size.create!(size: "S")
Size.create!(size: "M")
Size.create!(size: "L")
Size.create!(size: "XL")
Size.create!(size: "XXL")

User.create!(name:  "taniiiiim",
             real_name: "Yuki Tani",
             email: "tani.yuuki@lmi.ne.jp",
             password: "Treasure1131",
             password_confirmation: "Treasure1131",
             gender: "Male",
             birthdate: "1993-12-01",
             code: "241-0836",
             address: "神奈川県横浜市旭区万騎が原64-23")
=end
User.create!(name:  "Example User",
             real_name: "Example",
             email: "example@railstutorial.org",
             password: "Treasure1131",
             password_confirmation: "Treasure1131",
             gender: "Male",
             birthdate: "1993-12-01",
             code: "241-0836",
             address: "神奈川県横浜市旭区万騎が原64-23")

=begin
100000.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email)
  Product.create!(name: email,
                  gender_id: Random.rand(3) + 1,
                  category_id: Random.rand(6) + 1,
                  size_id: Random.rand(5) + 1,
                  price: Random.rand(10000) + 1,
                  abstract: email)
end
=end

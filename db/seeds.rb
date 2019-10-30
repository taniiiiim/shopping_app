# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
             email: "tani.yuuki@lmi.ne.jp")

User.create!(name:  "Example User",
             email: "example@railstutorial.org")

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


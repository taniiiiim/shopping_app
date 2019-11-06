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

User.first.update_attributes(name:  "taniiiiim",
             real_name: "Yuki Tani",
             email: "tani.yuuki@lmi.ne.jp",
             password: "Treasure1131",
             password_confirmation: "Treasure1131",
             gender: "Male",
             birthdate: "1993-12-01",
             code: "241-0836",
             address: "神奈川県横浜市旭区万騎が原64-23",
             activated: true,
             activated_at: Time.zone.now,
             admin: true)

User.second.update_attributes(name:  "Example User",
             real_name: "Example",
             email: "example@railstutorial.org",
             password: "Treasure1131",
             password_confirmation: "Treasure1131",
             gender: "Male",
             birthdate: "1993-12-01",
             code: "241-0836",
             address: "神奈川県横浜市旭区万騎が原64-23",
             activated: false,
             admin: false)
=end
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

Category.create!(category: "skirt")
Category.create!(category: "jacket")
Category.create!(category: "short-pants")
Category.find(5).update_attribute(:category, "pants")
Category.create!(category: "accessory")
=end
=begin

for g in (1..3)
for s in (1..5)

Product.create!(name: "Ultralightdown" + " #{Size.find(s).size}" + " #{Gender.find(g).gender}",
                gender_id: g,
                category_id: 1,
                size_id: s,
                price: 4000,
                abstract: "とっても軽くて暖かいダウンジャケット。冬には必須。")

Product.create!(name: "Non-hood parker" + " #{Size.find(s).size}" + " #{Gender.find(g).gender}",
                gender_id: g,
                category_id: 2,
                size_id: s,
                price: 3000,
                abstract: "フードの付いていないパーカー。老若男女問わず愛される逸品です。")

Product.create!(name: "Business shirt" + " #{Size.find(s).size}" + " #{Gender.find(g).gender}",
                gender_id: g,
                category_id: 3,
                size_id: s,
                price: 3000,
                abstract: "良質な素材を使用した、アイロンいらずのワイシャツ。")

Product.create!(name: "T-shirt(short)" + " #{Size.find(s).size}" + " #{Gender.find(g).gender}",
                gender_id: g,
                category_id: 4,
                size_id: s,
                price: 1500,
                abstract: "シンプルなコーディネーションに最適な、単色のTシャツ。")

Product.create!(name: "Stretch jeans" + " #{Size.find(s).size}" + " #{Gender.find(g).gender}",
                gender_id: g,
                category_id: 5,
                size_id: s,
                price: 3000,
                abstract: "伸縮性抜群の素材でできた大人気のジーンズ。")
end
end

for s in (1..5)
Product.create!(name: "Pleated skirt" + " #{Size.find(s).size}",
                gender_id: 2,
                category_id: 6,
                size_id: s,
                price: 3000,
                abstract: "春先に着たくなるパステルカラーのスカート。")

Product.create!(name: "Short-pants" + " #{Size.find(s).size}",
                gender_id: 1,
                category_id: 8,
                size_id: s,
                price: 3000,
                abstract: "夏に欠かせない、男性必携のおしゃれハーフパンツ。")
end
=end
=begin
i = Product.first.id
while i <= Product.last.id
  Stock.create!(product_id: i, stock: 100000)
  Product.find(i).update_attribute(:stock_id, Stock.last.id)
  i += 1
end
=end

#Order.create!(user_id: 1, code: "241-0836", address: "神奈川県横浜市旭区万騎が原64-23", ordered: true, cart_created_at: Time.now, ordered_at: Time.now)

for i in (1..10)
Detail.create!(order_id: 3, product_id: 260 + 5*i, amount: 1)
end

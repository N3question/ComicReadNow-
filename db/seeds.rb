# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin.create!(
#     email: 'narumi1years.years020@gmail.com',
#     password: 'n10aru203320',
# )

admins = [
    {email: 'narumi1years.years020@gmail.com', password: 'n10aru203320'},
]

admins.each do |admin|
    admin_data = Admin.find_by(email: admin[:email])
    if admin_data.nil?
        Admin.create(email: admin[:email], password: admin[:password])
    end
end

sites = ['コミック！', 'COMIC漫画', 'Comic Comic']
sites.each do |site|
    Site.find_or_create_by(name: site)
    # モデル.find_or_create_by(条件, ブロック引数)...条件を指定して初めの1件を取得し1件もなければ作成
end

# User.create!(
#   user_id: 1,
#   nick_name: "HYUNG's",
#   email: "sample320@gmail.com",
#   profile_image: File.open("./app/assets/images/")
# )

# User.create!(
#   user_id: 2,
#   nick_name: "LEE'know",
#   email: "sample1025@gmail.com",
#   profile_image: File.open("./app/assets/images/no_image.jpg")
# )

# User.create!(
#   user_id: 3,
#   nick_name: "NANA's",
#   email: "sample77@gmail.com",
#   profile_image: File.open("./app/assets/images/no_image.jpg")
# )

# User.create!(
#   user_id: 4,
#   nick_name: "Han_J",
#   email: "sample000@gmail.com",
#   profile_image: File.open("./app/assets/images/no_image.jpg")
# )
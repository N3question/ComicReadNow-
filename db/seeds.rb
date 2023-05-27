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

user = User.create!(
  nick_name: "HYUNG's",
  email: "sample320@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user1.png')), filename: 'user1.png')

user = User.create!(
  nick_name: "LEE'know",
  email: "sample1025@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user2.png')), filename: 'user2.png')

user = User.create!(
  nick_name: "NANA",
  email: "sample77@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user3.png')), filename: 'user3.png')

user = User.create!(
  nick_name: "Han_j",
  email: "sample000@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user4.png')), filename: 'user4.png')

user = User.create!(
  nick_name: "F.bird",
  email: "sample915@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user5.png')), filename: 'user5.png')

user = User.create!(
  nick_name: "Marioo'z",
  email: "sample1230@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user6.png')), filename: 'user6.png')

user = User.create!(
  nick_name: "???BLOCK",
  email: "sample???@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user7.png')), filename: 'user7.png')

user = User.create!(
  nick_name: "jo_jo",
  email: "sample5@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user8.png')), filename: 'user8.png')

user = User.create!(
  nick_name: "Rambo<3",
  email: "sample3030@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user9.png')), filename: 'user9.png')

user = User.create!(
  nick_name: "MIYAmoto",
  email: "sample38@gmail.com",
  password: "sample", 
  password_confirmation: "sample",
)
user.profile_image.attach(io: File.open(Rails.root.join('app/assets/images/user10.png')), filename: 'user10.png')
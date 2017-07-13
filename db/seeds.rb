# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup, aisle: "meat").
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }], aisle: "meat")
#   Mayor.create(name: 'Emanuel', city: cities.first, aisle: "meat")

Food.create!(name:  "* 2 oz spaghetti",
            calories: 371,
             carbohydrates: 75,
             fat: 1,
             protein: 1,
             sugar: 1,
             vitamin_a: 1,
             vitamin_c: 1,
             potassium: 223,
             fiber: 3,
             calcium: 21,
             iron: 3.3,
             sodium: 6,
             price: 0.17,
             food_store: "BLSmart",
             food_store_id: 1, 
             aisle: "produce")
             
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'


20.times do
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true)
  )
  rand(1..3).times do
    Flat.create!(
      name: Faker::Commerce.product_name,
      address: Faker::Address.full_address,
      description: Faker::Lorem.paragraph,
      price: Faker::Number.between(from: 50, to: 500),
      user: user
        # number_of_guests: Faker::Number.between(from: 1, to: 6)
    )
  end
end

puts "Created #{Flat.count} flats and 20 users!"

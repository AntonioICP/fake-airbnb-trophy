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
require 'open-uri'
require 'json'

puts "Cleaning up..."
Flat.destroy_all
User.destroy_all

puts "Fetching images from Unsplash..."

# Apartment images
apartment_url = "https://api.unsplash.com/search/photos?query=apartment&per_page=30&client_id=#{ENV['UNSPLASH_ACCESS_KEY']}"
apartment_response = URI.open(apartment_url).read
apartment_data = JSON.parse(apartment_response)
apartment_images = apartment_data["results"].map { |r| r["urls"]["regular"] }

# Avatar images (using "portrait" query)
avatar_url = "https://api.unsplash.com/search/photos?query=portrait&per_page=30&client_id=#{ENV['UNSPLASH_ACCESS_KEY']}"
avatar_response = URI.open(avatar_url).read
avatar_data = JSON.parse(avatar_response)
avatar_images = avatar_data["results"].map { |r| r["urls"]["small"] }

puts "Seeding users and flats..."

20.times do
  user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 123456,
    # Faker::Internet.password(min_length: 8, mix_case: true, special_characters: true),
    avatar_url: avatar_images.sample
  )

  rand(1..3).times do
    Flat.create!(
      name: Faker::Commerce.product_name,
      address: Faker::Address.full_address,
      description: Faker::Lorem.paragraph,
      price: rand(50..500),
      image_url: apartment_images.sample,
      user: user
    )
  end
end

puts "✅ Created #{Flat.count} flats and #{User.count} users!"

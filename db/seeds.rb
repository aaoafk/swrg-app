# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Clear existing groups to avoid duplicates
puts "Clearing existing groups..."
Group.destroy_all

# Create reading groups with interesting book themes
READING_THEMES = [
  "Classic Literature",
  "Contemporary Fiction",
  "Science Fiction & Fantasy",
  "Mystery & Thriller",
  "Poetry & Prose",
  "Philosophy & Ethics",
  "Historical Fiction",
  "World Literature"
]

puts "Creating reading groups..."
READING_THEMES.each do |theme|
  Group.create!(
    name: "#{theme} Circle",
    group_type: :reading_group,
    max_size: Faker::Number.between(from: 5, to: 15)
  )
end

# Create some basic groups for testing
3.times do
  Group.create!(
    name: "#{Faker::University.name} Discussion Group",
    group_type: :basic,
    max_size: -1  # unlimited size
  )
end

puts "Created #{Group.count} groups:"
Group.all.each do |group|
  puts "- #{group.name} (max size: #{group.max_size == -1 ? 'unlimited' : group.max_size})"
end

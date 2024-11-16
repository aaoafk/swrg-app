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

# Create meetings for each group
puts "Creating meetings..."
Group.all.each do |group|
  # Create 3 past meetings
  3.times do |i|
    meeting = group.meetings.create!(
      date: (i + 1).weeks.ago
    )

    meeting.create_location!(
      address: Faker::Address.full_address
    )
  end

  # Create 3 upcoming meetings
  3.times do |i|
    meeting = group.meetings.create!(
      date: (i + 1).weeks.from_now
    )

    meeting.create_location!(
      address: Faker::Address.full_address
    )
  end
end

puts "Created #{Group.count} groups with #{Meeting.count} meetings"
Group.all.each do |group|
  puts "- #{group.name}"
  puts "  Upcoming meetings: #{group.upcoming_meetings.count}"
  group.upcoming_meetings.each do |meeting|
    puts "    - #{meeting.date.strftime("%B %d, %Y at %I:%M %p")} at #{meeting.location.address}"
  end
end

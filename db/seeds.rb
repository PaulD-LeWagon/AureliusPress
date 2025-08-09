# Load Factory Bot definitions
# Needed when running seeds outside of test environment
require "factory_bot_rails"
# FactoryBot.find_definitions

puts "Seeding development database..."

# Clear existing data to ensure a fresh start each time you run seeds
AureliusPress::User.destroy_all

[
  AureliusPress::Document::Document.namespaced_types,
  AureliusPress::Fragment::Fragment.namespaced_types,
].flatten.each do |type|
  puts "Clearing #{type} records..."
  Object.const_get(type).destroy_all
end

AureliusPress::ContentBlock::ContentBlock.destroy_all
AureliusPress::Taxonomy::Category.destroy_all
AureliusPress::Taxonomy::Tag.destroy_all
AureliusPress::Community::Like.destroy_all

puts "  Cleared existing data."

docs = %i[
  aurelius_press_document_atomic_blog_post
  aurelius_press_document_blog_post
  aurelius_press_document_page
]

users_array = []

users_data = [
  {
    first_name: "Paul",
    last_name: "Devanney",
    email: "pauldevanney92@gmail.com",
    role: :superuser,
  },
  {
    first_name: "Yvonne",
    last_name: "Amores-Cabrera",
    email: "yvonne.amores-cabrera@gmail.com",
    role: :admin,
  },
  {
    first_name: "Bebe",
    last_name: "Rexha",
    email: "bebe.rexha@gmail.com",
    role: :moderator,
  },
  {
    first_name: "Becky",
    last_name: "Hill",
    email: "becky.hill@gmail.com",
    role: :moderator,
  },
  {
    first_name: "Dua",
    last_name: "Lipa",
    email: "dua.lipa@gmail.com",
    role: :reader,
  },
  {
    first_name: "Anna",
    last_name: "Montana",
    email: "anna.montana@gmail.com",
    role: :reader,
  },
]

15.times do
  users_data << {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    role: [:reader, :user, :moderator, :admin, :superuser].sample,
  }
end

users_data.each do |user_data|
  users_array << FactoryBot.create(
    :aurelius_press_user,
    first_name: user_data[:first_name],
    last_name: user_data[:last_name],
    email: user_data[:email],
    role: user_data[:role],
    password: "password",
    password_confirmation: "password",
  )
end

users_array.each do |user|
  puts "Created user: #{user.full_name} with role: #{user.role}"
end

status_trait = [:draft, :published, :archived]

puts "Creating categories..."
categories = [
  "Stoic Philosophy",
  "Stoic Practices",
  "Stoic Texts",
  "Stoic History",
  "Stoic Community",
  "Stoic Resources",
  "Stoic Events",
].map do |name|
  FactoryBot.create(:aurelius_press_taxonomy_category, name: name)
end
puts "  Generated: #{categories.map(&:name).join(", \n")}"

10.times do
  user = users_array.sample
  puts "Creating documents by #{user.full_name}..."
  FactoryBot.create(
    docs.sample,
    :with_belt_and_braces,
    user: user,
    category: categories.sample,
  )
end

5.times do
  user = users_array.sample
  puts "Creating a document with content blocks by #{user.full_name}..."
  FactoryBot.create(
    %i[
      aurelius_press_document_blog_post
      aurelius_press_document_page
    ].sample,
    :with_one_of_each_content_block,
    status_trait.sample,
    user: user,
    category: categories.sample,
  )
end

puts "Database seeding complete!"

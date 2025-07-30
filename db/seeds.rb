# Load Factory Bot definitions
# Needed when running seeds outside of test environment
require "factory_bot_rails"
# FactoryBot.find_definitions

# Clear any existing validators and callbacks that might be causing issues
# Book.clear_validators!
# Book.reset_callbacks(:validation)

docs = %i[aurelius_press_document_blog_post aurelius_press_document_page]

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

puts "Creating users..."

admin_user = FactoryBot.create(
  :aurelius_press_user,
  email: "admin@istrator.com",
  password: "password",
  password_confirmation: "password",
)

puts "  Created Admin User: #{admin_user.email}"

status_trait = [:draft, :published, :archived]

# Create some categories
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

puts "  Created Categories: #{categories.map(&:name).join(", ")}"

# Create documents using your factories
puts "Creating blog posts with #{admin_user.email}..."

3.times do
  FactoryBot.create(
    docs.sample,
    :with_belt_and_braces,
    status_trait.sample,
    user: admin_user,
    category: categories.sample,
  )
end

puts "  Created Blog Posts with #{admin_user.email}"

editor_user = FactoryBot.create(
  :aurelius_press_user,
  email: "editor@ials.com",
  password: "password",
  password_confirmation: "password",
)

puts "  Created Editor User: #{editor_user.email}"

puts "Creating pages with #{editor_user.email}..."

3.times do
  # Using the :draft trait to create draft documents
  FactoryBot.create(
    docs.sample,
    status_trait.sample,
    user: editor_user,
    category: categories.sample,
  )
end

moderator_user = FactoryBot.create(
  :aurelius_press_user,
  email: "mod@erator.com",
  password: "password",
  password_confirmation: "password",
)

puts "  Created Moderator User: #{moderator_user.email}"

puts "Creating journal entries with #{moderator_user.email}..."

3.times do
  # Using the :draft trait to create draft documents
  FactoryBot.create(
    docs.sample,
    :with_one_of_each_content_block,
    status_trait.sample,
    user: editor_user,
    category: categories.sample,
  )
end

puts "Database seeding complete!"

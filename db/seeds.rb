# Load Factory Bot definitions
# Needed when running seeds outside of test environment
require "factory_bot_rails"
# FactoryBot.find_definitions

puts "Seeding development database..."

# Clear existing data to ensure a fresh start each time you run seeds
User.destroy_all

Document::TYPES.each do |type|
  Object.const_get(type).destroy_all
end

# BlogPost.destroy_aContentBlock::TYPES.sample.underscore.to_symll
# Page.destroy_all
# JournalEntry.destroy_all
# AtomicBlogPost.destroy_all
# Comment.replies.destroy_all # Clear nested comments first

Comment.destroy_all
Note.destroy_all

Category.destroy_all
Tag.destroy_all
puts "  Cleared existing data."

# p ContentBlock::TYPES.sample.underscore.to_sym
# p ContentBlock::TYPES
# p ContentBlock::TYPES.each { |type| p type.underscore.to_sym }
# p FactoryBot.create(:rich_text_block)
# p FactoryBot.create(:image_block)
# p FactoryBot.create(:gallery_block)
# p FactoryBot.create(:video_embed_block)

# rt = FactoryBot.build(:rich_text_block, :attached_to_a, document_obj: FactoryBot.create(:blog_post))
# p rt.content_block.document.class.name
# p rt.content_block.class.name
# p rt.class.name
# p rt.body.to_plain_text
# p rt.body
# exit

# bp = FactoryBot.create(:blog_post, :with_one_of_each_content_block, :public_to_www)
# bp.content_blocks.image_blocks.each do |b|
#   cb = b.contentable
#   p "#{cb.class.name} - #{cb.body}"
# end
# exit

puts "Creating users..."

admin_user = FactoryBot.create(
  :user,
  email: "admin@istrator.com",
  password: "password",
  password_confirmation: "password",
)

puts "  Created Admin User: #{admin_user.email}"

editor_user = FactoryBot.create(
  :user,
  email: "editor@ials.com",
  password: "password",
  password_confirmation: "password",
)

puts "  Created Editor User: #{editor_user.email}"

moderator_user = FactoryBot.create(
  :user,
  email: "mod@erator.com",
  password: "password",
  password_confirmation: "password",
)

puts "  Created Moderator User: #{moderator_user.email}"

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
  FactoryBot.create(:category, name: name)
end

puts "  Created Categories: #{categories.map(&:name).join(", ")}"

# Create documents using your factories
puts "Creating documents..."

3.times do
  FactoryBot.create(
    :blog_post,
    :with_belt_and_braces,
    status_trait.sample,
    user: admin_user,
    category: categories.sample,
    comments_enabled: true,
  )
end

3.times do
  # Using the :draft trait to create draft documents
  FactoryBot.create(
    :page,
    status_trait.sample,
    user: editor_user,
    category: categories.sample,
  )
end

3.times do
  # Using the :draft trait to create draft documents
  FactoryBot.create(
    :journal_entry,
    :with_one_of_each_content_block,
    status_trait.sample,
    user: editor_user,
    category: categories.sample,
    comments_enabled: true,
  )
end

puts "Database seeding complete!"

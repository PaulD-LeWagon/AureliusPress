# spec/factories/blog_posts.rb
FactoryBot.define do
  factory :blog_post, parent: :document do
    type { "BlogPost" }
    # You might add specific BlogPost attributes here if they existed
    # For example: comments_enabled { true }
  end
end

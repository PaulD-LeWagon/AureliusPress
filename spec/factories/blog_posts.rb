# spec/factories/blog_posts.rb
FactoryBot.define do
  factory :blog_post, parent: :document, class: BlogPost do
    type { "BlogPost" }
    comments_enabled { true }
    visibility { :public_to_www }
  end
end

# spec/factories/comments.rb
FactoryBot.define do
  factory :comment do
    # Association to User who made the comment
    association :user

    # Polymorphic association for commentable
    # You can specify the commentable type, e.g., 'document' or 'blog_post' or another 'comment'
    # Example: association :commentable, factory: :blog_post
    # For a generic commentable that's a Document, you could do:
    association :commentable, factory: :document # Assuming comments can be on any Document

    # Enums
    visibility { Comment.visibilities.keys.sample }

    # For polymorphic associations, make sure commentable is valid
    trait :on_blog_post do
      association :commentable, factory: :blog_post
    end

    trait :on_another_comment do
      association :commentable, factory: :comment # Nested comment
    end
  end
end

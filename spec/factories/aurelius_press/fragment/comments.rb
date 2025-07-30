FactoryBot.define do
  factory :aurelius_press_fragment_comment, parent: :aurelius_press_fragment_fragment, class: "AureliusPress::Fragment::Comment" do
    :aurelius_press_on_blog_post # Default association for commentable, can be overridden by traits
    # Attributes: @see-above for Fragment attributes
    # [Required] - content: text, rich text content for fragments that support it

    type { "AureliusPress::Fragment::Comment" }
    # content { Faker::Lorem.paragraphs(number: 3).join("\n\n") } # Generates realistic content for the comment
    status { :draft } # Default status for comments
    visibility { :private_to_owner } # Default visibility for comments

    # Default to blog_post, can be overridden by traits, below..
    association :commentable, factory: :aurelius_press_document_blog_post

    # Traits for different commentable types
    trait :on_blog_post do
      association :commentable, factory: :aurelius_press_document_blog_post
    end

    # This will currently fail as the Document model forbids it!
    trait :on_page do
      association :commentable, factory: :aurelius_press_document_page
    end

    trait :on_atomic_blog_post do
      association :commentable, factory: :aurelius_press_document_atomic_blog_post
    end

    trait :on_journal_entry do
      association :commentable, factory: :aurelius_press_document_journal_entry
    end

    trait :on_another_comment do
      association :commentable, factory: :aurelius_press_fragment_comment # For nested comments/replies
    end

    after(:build) do |comment|
      # Action Text: Assign a string directly to the content attribute
      comment.content = Faker::Lorem.paragraphs(number: 3).join("\n\n")
    end
  end
end

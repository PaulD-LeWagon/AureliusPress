FactoryBot.define do
  factory :aurelius_press_document_atomic_blog_post, parent: :aurelius_press_document_document, class: "AureliusPress::Document::AtomicBlogPost" do
    type { "AureliusPress::Document::AtomicBlogPost" }
    sequence(:title) { |n| "ABP #{Faker::Book.title} #{n}" }
    slug { title.parameterize }
    status { :published }
    visibility { :public_to_www }
    published_at { Time.current }
    # Action Text: Attaches rich text content.
    # This requires an instance of ActionText::RichText to be associated.
    # The `content` attribute is what Trix editor binds to.
    after(:build) do |document|
      # Ensure content is always present for ActionText fields
      document.content = ActionText::RichText.new(body: Faker::Lorem.paragraphs(number: 3).join("\n\n"))
      document.image_file.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.png")),
        filename: "test_image.png",
        content_type: "image/png",
      )
    end
  end
end

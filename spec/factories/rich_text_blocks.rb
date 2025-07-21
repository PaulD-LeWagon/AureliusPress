# spec/factories/rich_text_blocks.rb
FactoryBot.define do
  factory :rich_text_block do
    # Has one content block associated with this rich text block
    # @see traits.rb
    # @trait
    # :attached_to_a, document_type: :blog_post || document_obj: create(:blog_post)
    #
    association :content_block, factory: :content_block
    # Double set the body attribute for good measure
    body {
      ActionText::RichText.new(
        body: Faker::Lorem.paragraphs(
          number: 2,
        ).join("\n\n"),
      )
    }
    # Action Text content for the body
    after(:build) do |block|
      block.body = ActionText::RichText.new(
        body: Faker::Lorem
          .paragraphs(number: 2)
          .join("\n\n"),
      )
    end

    trait :without_content do
      after(:build) do |block|
        block.body = nil
      end
    end
  end
end

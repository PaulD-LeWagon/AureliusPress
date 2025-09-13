# == Schema Information
#
# Table name: aurelius_press_rich_text_blocks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :aurelius_press_content_block_rich_text_block, class: "AureliusPress::ContentBlock::RichTextBlock" do
    # Has one content block associated with this rich text block
    # @see traits.rb
    # @trait
    # :attached_to_a, document_type: :blog_post || document_obj: create(:blog_post)
    #
    association :content_block, factory: :aurelius_press_content_block_content_block, strategy: :build
    # Double set the content attribute for good measure
    content {
      ActionText::RichText.new(
        body: Faker::Lorem.paragraphs(
          number: 2,
        ).join("\n\n"),
      )
    }
    # Action Text content for the content attribute
    after(:build) do |block|
      block.content = ActionText::RichText.new(
        body: Faker::Lorem
          .paragraphs(number: 2)
          .join("\n\n"),
      )
    end

    trait :without_content do
      after(:build) do |block|
        block.content = nil
      end
    end
  end
end

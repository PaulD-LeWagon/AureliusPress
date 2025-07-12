# spec/factories/rich_text_blocks.rb
FactoryBot.define do
  factory :rich_text_block do
    # Each specific block type belongs to a ContentBlock
    association :content_block
    # Action Text content for the body
    after(:build) do |block|
      block.body = ActionText::RichText.new(body: Faker::Lorem.paragraphs(number: 2).join("\n\n"))
    end
  end
end

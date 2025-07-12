# spec/factories/image_blocks.rb
FactoryBot.define do
  factory :image_block do
    association :content_block
    caption { Faker::Lorem.sentence(word_count: 5) }
    alignment { ImageBlock.alignments.keys.sample }

    after(:build) do |block|
      unless block.image.attached?
        block.image.attach(io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.png")), filename: "test_image.png", content_type: "image/png")
      end
    end
  end
end

# spec/factories/image_blocks.rb
FactoryBot.define do
  factory :image_block do
    caption { Faker::Lorem.sentence(word_count: 5) }
    alignment { ImageBlock.alignments.keys.first }

    after(:build) do |block|
      unless block.image.attached?
        block.image.attach(
          io: File.open(Rails.root.join(
            "spec",
            "fixtures",
            "files",
            "test_image.png"
          )),
          filename: "test_image.png",
          content_type: "image/png",
        )
      end
    end

    trait :with_link do
      link_url { "https://example.com" }
      link_title { "Example" }
      link_class { "example-class" }
      link_target { "_blank" }
      link_text { caption || "Click here" }
    end
  end
end

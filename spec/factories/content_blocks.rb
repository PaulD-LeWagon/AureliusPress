# spec/factories/content_blocks.rb
FactoryBot.define do
  factory :content_block do
    association :document
    sequence(:position) { |n| n } # Ensures unique position per document scope when multiple blocks are created

    # New HTML attributes
    html_id { "block-#{Faker::Internet.unique.slug(words: 2, separator: "-")}" } # Unique slug for ID
    html_class { "custom-#{Faker::Lorem.word} another-class" } # Space-separated classes
    data_attributes { { "data-custom-attribute" => Faker::Lorem.word, "data-test-value" => SecureRandom.uuid } }
  end
end

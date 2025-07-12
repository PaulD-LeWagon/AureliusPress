# spec/factories/video_embed_blocks.rb
FactoryBot.define do
  factory :video_embed_block do
    association :content_block
    embed_code { '<iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>' }
    description { Faker::Lorem.sentence(word_count: 7) }
  end
end

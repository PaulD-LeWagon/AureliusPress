# == Schema Information
#
# Table name: aurelius_press_video_embed_blocks
#
#  id          :bigint           not null, primary key
#  embed_code  :text
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  video_url   :string
#
FactoryBot.define do
  factory :aurelius_press_content_block_video_embed_block, class: "AureliusPress::ContentBlock::VideoEmbedBlock" do

    # The embed_code will be set by the before_validation callback,
    # so we don't need to set it directly in the factory for valid instances.
    # However, for specific test cases (e.g., testing presence validation before callback runs),
    # you might temporarily set it or leave it out.
    embed_code { nil } # This will be set by the before_validation callback if left unset
    # Valid YouTube video URL for testing
    video_url { "https://www.youtube.com/watch?v=#{%w[jOa7SN232EM 0ir1qkPXPVM 7xWsXTXsbtI vTAOh1ARBOI].sample}" }
    description { Faker::Lorem.sentence(word_count: 10) }

    trait :with_embed_code do                                   
      embed_code { "0ir1qkPXPVM" }
    end

    trait :with_short_youtube_url do
      video_url { "https://youtu.be/7xWsXTXsbtI" }
    end

    trait :with_youtube_list_url do
      video_url { "https://www.youtube.com/watch?v=jOa7SN232EM" }
    end

    trait :with_vimeo_url do
      # This will fail as the Vimeo URL is not a valid YouTube URL
      video_url { "https://vimeo.com/VIDEO_ID456" }
    end

    trait :with_invalid_video_url do
      video_url { "http://www.example.com/not-a-video.mp3" }
    end

    trait :with_nil_fields do
      video_url { nil }
      embed_code { nil }
      description { nil }
    end

    trait :with_belt_and_braces do
      video_url { "https://youtu.be/vTAOh1ARBOI?list=RDGMEMQ1dJ7wXfLlqCjwV0xfSNbAVM0ir1qkPXPVM" }
      embed_code { "vTAOh1ARBOI" }
      description { "Bebe Rexha - Sacrifice (Official Music Video)" }
    end
  end
end

# == Schema Information
#
# Table name: aurelius_press_content_blocks
#
#  id               :bigint           not null, primary key
#  document_id      :bigint           not null
#  contentable_type :string           not null
#  contentable_id   :bigint           not null
#  position         :integer          default(0), not null
#  html_id          :string
#  html_class       :string
#  data_attributes  :jsonb
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# spec/factories/content_blocks.rb
FactoryBot.define do
  factory :aurelius_press_content_block_content_block, class: "AureliusPress::ContentBlock::ContentBlock" do
    # When creating a `content_block` directly, you must specify its `contentable`
    # E.g., create(:content_block, contentable: create(:image_block))

    association :document, factory: :aurelius_press_document_page, strategy: :build

    # Ensures unique position per document scope when multiple blocks are created
    sequence(:position) { |n| n }
    # New HTML attributes
    # Generates a unique HTML ID for each block
    sequence(:html_id) { |n| Faker::Internet.slug(words: "block #{n} #{Faker::Lorem.words(number: 3, supplemental: true).join(" ")}", glue: "-") }
    # Space-separated classes
    html_class { "custom-#{Faker::Lorem.word} another-class" }
    data_attributes { "" }

    trait :on_a_page do
      document { build(:aurelius_press_document_page) }
    end

    trait :on_a_blog_post do
      document { build(:aurelius_press_document_blog_post) }
    end

    trait :on_a_journal_entry do
      document { build(:aurelius_press_document_journal_entry) }
    end

    trait :as_rich_text_block do
      after(:build) do |block|
        block.contentable = build(:aurelius_press_content_block_rich_text_block, content_block: block)
      end
    end

    trait :as_image_block do
      after(:build) do |block|
        block.contentable = build(:aurelius_press_content_block_image_block, content_block: block)
      end
    end

    trait :as_gallery_block do
      after(:build) do |block|
        block.contentable = build(:aurelius_press_content_block_gallery_block, content_block: block)
      end
    end

    trait :as_video_embed_block do
      after(:build) do |block|
        block.contentable = build(:aurelius_press_content_block_video_embed_block, content_block: block)
      end
    end

    # trait :as_an_audio_block do
    #   association :contentable, factory: :aurelius_press_content_block_audio_block
    # end

    # trait :as_a_code_block do
    #   association :contentable, factory: :aurelius_press_content_block_code_block
    # end

    # trait :as_a_link_block do
    #   association :contentable, factory: :aurelius_press_content_block_link_block
    # end
  end
end

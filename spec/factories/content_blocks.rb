# spec/factories/content_blocks.rb
FactoryBot.define do
  factory :content_block do
    # When creating a `content_block` directly, you must specify its `contentable`
    # E.g., create(:content_block, contentable: create(:image_block))

    association :document, factory: :page

    # Ensures unique position per document scope when multiple blocks are created
    sequence(:position) { |n| n }
    # New HTML attributes
    # Generates a unique HTML ID for each block
    sequence(:html_id) { |n| Faker::Internet.slug(words: "block #{n} #{Faker::Lorem.words(number: 3, supplemental: true).join(" ")}", glue: "-") }
    # Space-separated classes
    html_class { "custom-#{Faker::Lorem.word} another-class" }
    data_attributes { {} }

    trait :on_a_page do
      document { build(:page) }
    end

    trait :on_a_blog_post do
      document { build(:blog_post) }
    end

    trait :on_a_journal_entry do
      document { build(:journal_entry) }
    end

    trait :as_rich_text_block do
      contentable { build(:rich_text_block) }
    end

    trait :as_image_block do
      contentable { build(:image_block) }
    end

    trait :as_gallery_block do
      contentable { build(:gallery_block) }
    end

    trait :as_video_embed_block do
      contentable { build(:video_embed_block) }
    end

    # trait :as_an_audio_block do
    #   association :contentable, factory: :audio_block
    # end

    # trait :as_a_code_block do
    #   association :contentable, factory: :code_block
    # end

    # trait :as_a_link_block do
    #   association :contentable, factory: :link_block
    # end
  end
end

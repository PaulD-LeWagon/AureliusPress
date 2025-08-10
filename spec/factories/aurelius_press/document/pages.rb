# == Schema Information
#
# Table name: aurelius_press_documents
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  category_id      :bigint
#  type             :string           not null
#  slug             :string           not null
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  status           :integer          default("draft"), not null
#  visibility       :integer          default("private_to_owner"), not null
#  published_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
# spec/factories/pages.rb
FactoryBot.define do
  # Inherits all attributes and associations from the :document factory
  # The `type` attribute is set to 'Page' by the :page trait in document factory
  factory :aurelius_press_document_page, parent: :aurelius_press_document_document, class: "AureliusPress::Document::Page" do
    type { "AureliusPress::Document::Page" }
    sequence(:title) { |n| "#{%w[Home About Services Pricing Contact Sitemap].sample} Page [#{n}]" }
    subtitle { Faker::Lorem.sentence(word_count: 5) } # A short random gibberish subtitle
    status { :draft }
    visibility { :public_to_www }
    trait :with_belt_and_braces do
      # Ensures all attributes are set for a complete Page.
      description { Faker::Lorem.paragraph(sentence_count: 3) }
      comments_enabled { false }
      visible_to_www
      published_1_month_ago
      with_content_blocks
      with_category
      with_tags
      with_notes
      with_likes
    end
  end
end

# == Schema Information
#
# Table name: aurelius_press_taggings
#
#  id          :bigint           not null, primary key
#  document_id :bigint           not null
#  tag_id      :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :aurelius_press_taxonomy_tagging, class: "AureliusPress::Taxonomy::Tagging" do
    # Associates with an existing document and tag
    association :document, factory: :aurelius_press_document_blog_post
    # Using a factory for the tag to ensure it exists
    association :tag, factory: :aurelius_press_taxonomy_tag
  end
end

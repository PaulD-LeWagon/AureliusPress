FactoryBot.define do
  factory :aurelius_press_taxonomy_tagging, class: "AureliusPress::Taxonomy::Tagging" do
    association :tag, factory: :aurelius_press_taxonomy_tag, strategy: :create

    trait :quote do
      association :taggable, factory: :aurelius_press_catalogue_quote, strategy: :create
    end

    trait :source do
      association :taggable, factory: :aurelius_press_catalogue_source, strategy: :create
    end

    trait :blog_post do
      association :taggable, factory: :aurelius_press_document_blog_post, strategy: :create
    end

    trait :atomic_blog_post do
      association :taggable, factory: :aurelius_press_document_atomic_blog_post, strategy: :create
    end

    trait :page do
      association :taggable, factory: :aurelius_press_document_page, strategy: :create
    end

    blog_post
  end
end

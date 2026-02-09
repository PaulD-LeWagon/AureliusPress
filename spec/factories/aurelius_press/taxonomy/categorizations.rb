FactoryBot.define do
  factory :aurelius_press_taxonomy_categorization, class: "AureliusPress::Taxonomy::Categorization" do
    # Creates a category and associates it with the categorization
    association :category, factory: :aurelius_press_taxonomy_category, strategy: :create

    # The polymorphic association. We use a trait to specify the type.
    trait :atomic_blog_post do
      association :categorizable, factory: :aurelius_press_document_atomic_blog_post, strategy: :create
    end

    trait :blog_post do
      association :categorizable, factory: :aurelius_press_document_blog_post, strategy: :create
    end

    trait :page do
      association :categorizable, factory: :aurelius_press_document_page, strategy: :create
    end

    trait :quote do
      association :categorizable, factory: :aurelius_press_catalogue_quote, strategy: :create
    end

    trait :source do
      association :categorizable, factory: :aurelius_press_catalogue_source, strategy: :create
    end

    # Set a default
    blog_post
  end
end

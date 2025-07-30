FactoryBot.define do
  factory :aurelius_press_catalogue_affiliate_link, class: "AureliusPress::Catalogue::AffiliateLink" do
    url { "https://#{Faker::Internet.domain_name}/#{Faker::Internet.slug}" } # Use Faker for realistic URLs
    text { Faker::Commerce.product_name } # More realistic text
    description { Faker::Lorem.sentence }
    # Set a default linkable (e.g., to an author) for convenience, can be overridden.
    association :linkable, factory: :aurelius_press_catalogue_author, strategy: :build

    trait :on_a_source do
      association :linkable, factory: :aurelius_press_catalogue_source, strategy: :build
    end

    trait :on_a_quote do
      association :linkable, factory: :aurelius_press_catalogue_quote, strategy: :build
    end
  end
end

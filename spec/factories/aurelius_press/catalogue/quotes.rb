FactoryBot.define do
  factory :aurelius_press_catalogue_quote, class: "AureliusPress::Catalogue::Quote" do
    text { Faker::GreekPhilosophers.quote }
    context { Faker::Lorem.sentence }
    slug { nil } # Slug will be generated automatically
    # Ensure source is created by default for valid quotes
    association :source, factory: :aurelius_press_catalogue_source
    original_quote { nil }
  end
end

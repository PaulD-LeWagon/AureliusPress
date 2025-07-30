FactoryBot.define do
  factory :aurelius_press_taxonomy_category, class: "AureliusPress::Taxonomy::Category" do
    # Using sequence and Faker to ensure unique names for each category
    sequence(:name) { |n| "Category Name #{n} #{Faker::Lorem.word}" }
  end
end

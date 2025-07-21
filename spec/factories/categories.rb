FactoryBot.define do
  factory :category do
    # Using sequence and Faker to ensure unique names for each category
    sequence(:name) { |n| "Category Name #{n} #{Faker::Lorem.unique.word}" }
  end
end

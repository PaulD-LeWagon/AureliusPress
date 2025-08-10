# == Schema Information
#
# Table name: aurelius_press_categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :aurelius_press_taxonomy_category, class: "AureliusPress::Taxonomy::Category" do
    # Using sequence and Faker to ensure unique names for each category
    sequence(:name) { |n| "Category Name #{n} #{Faker::Lorem.word}" }
  end
end

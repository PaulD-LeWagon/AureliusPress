FactoryBot.define do
  factory :aurelius_press_catalogue_source, class: "AureliusPress::Catalogue::Source" do
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
    description { Faker::Lorem.paragraph }
    date { Faker::Date.between(from: "1900-01-01", to: Date.today) }
    isbn { Faker::Code.isbn }
  end
end

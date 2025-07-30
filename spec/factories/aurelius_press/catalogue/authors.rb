# spec/factories/aurelius_press/catalogue/authors.rb
FactoryBot.define do
  factory :aurelius_press_catalogue_author, class: "AureliusPress::Catalogue::Author" do
    sequence(:name) { |n| "#{Faker::GreekPhilosophers.name} #{n}" }
    bio { "#{Faker::GreekPhilosophers.quote} #{Faker::Lorem.paragraph}" }
  end
end

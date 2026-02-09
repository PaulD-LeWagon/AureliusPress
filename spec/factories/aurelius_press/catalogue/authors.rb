# == Schema Information
#
# Table name: aurelius_press_authors
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  slug             :string           not null
#  bio              :text
#  birth_date       :date
#  death_date       :date
#  comments_enabled :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# spec/factories/aurelius_press/catalogue/authors.rb
FactoryBot.define do
  factory :aurelius_press_catalogue_author, class: "AureliusPress::Catalogue::Author" do
    sequence(:name) { |n| "#{Faker::GreekPhilosophers.name} #{n}" }
    bio { "#{Faker::GreekPhilosophers.quote} #{Faker::Lorem.paragraph}" }
    birth_date { Faker::Date.backward(days: 365 * 100) }
    death_date { Faker::Date.backward(days: 365 * 10) }
    comments_enabled { [true, false].sample }
  end
end

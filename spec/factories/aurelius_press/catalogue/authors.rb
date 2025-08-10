# == Schema Information
#
# Table name: aurelius_press_authors
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  slug             :string           not null
#  bio              :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
# spec/factories/aurelius_press/catalogue/authors.rb
FactoryBot.define do
  factory :aurelius_press_catalogue_author, class: "AureliusPress::Catalogue::Author" do
    sequence(:name) { |n| "#{Faker::GreekPhilosophers.name} #{n}" }
    bio { "#{Faker::GreekPhilosophers.quote} #{Faker::Lorem.paragraph}" }
  end
end

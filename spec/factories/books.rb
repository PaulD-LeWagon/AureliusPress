FactoryBot.define do
  factory :book do
    sequence(:name) { |n| "#{Faker::Book.title} #{n}" }
    creator_id { create(:aurelius_press_user).id }
    status { "draft" }
    privacy_setting { "public" }
    alt_title { Faker::Lorem.words(number: 3).join(' ').titleize }
  end
end

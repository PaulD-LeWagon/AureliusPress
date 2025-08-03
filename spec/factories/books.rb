# == Schema Information
#
# Table name: books
#
#  id              :bigint           not null, primary key
#  name            :string
#  slug            :string
#  creator_id      :integer
#  status          :string
#  privacy_setting :string
#  alt_title       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :book do
    sequence(:name) { |n| "#{Faker::Book.title} #{n}" }
    creator_id { create(:aurelius_press_user).id }
    status { "draft" }
    privacy_setting { "public" }
    alt_title { Faker::Lorem.words(number: 3).join(' ').titleize }
  end
end

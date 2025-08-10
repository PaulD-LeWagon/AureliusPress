# == Schema Information
#
# Table name: aurelius_press_sources
#
#  id               :bigint           not null, primary key
#  title            :string
#  description      :text
#  source_type      :integer
#  date             :date
#  isbn             :string
#  slug             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
FactoryBot.define do
  factory :aurelius_press_catalogue_source, class: "AureliusPress::Catalogue::Source" do
    sequence(:title) { |n| "#{Faker::Book.title} #{n}" }
    description { Faker::Lorem.paragraph }
    date { Faker::Date.between(from: "1900-01-01", to: Date.today) }
    isbn { Faker::Code.isbn }
  end
end

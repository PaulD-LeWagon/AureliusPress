# == Schema Information
#
# Table name: aurelius_press_quotes
#
#  id                :bigint           not null, primary key
#  text              :text
#  context           :string
#  source_id         :bigint           not null
#  original_quote_id :bigint
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  comments_enabled  :boolean          default(FALSE), not null
#
FactoryBot.define do
  factory :aurelius_press_catalogue_quote, class: "AureliusPress::Catalogue::Quote" do
    text { Faker::GreekPhilosophers.quote }
    context { Faker::Lorem.sentence }
    slug { nil } # Slug will be generated automatically
    # Ensure source is created by default for valid quotes
    association :source, factory: :aurelius_press_catalogue_source
    original_quote { nil }
  end
end

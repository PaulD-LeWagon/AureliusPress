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
    source_type { AureliusPress::Catalogue::Source.source_types.keys.sample }
    date { Faker::Date.backward(days: 365 * 20) }
    isbn { Faker::Barcode.isbn }
    comments_enabled { [true, false].sample }
    # This creates a related Authorship and Author when the Source is created.
    # It ensures the 'authorships' presence validation on the Source model is met.
    after(:create) do |source|
      create(:aurelius_press_catalogue_authorship, source: source)
      # Create a categorization for the source to ensure it has at least one category
      create(:aurelius_press_taxonomy_categorization, categorizable: source)
    end
  end
end

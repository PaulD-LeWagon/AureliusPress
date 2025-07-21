FactoryBot.define do
  factory :application_records, class: ApplicationRecord do
    type { "ApplicationRecord" } # Default type for the document is ApplicationRecord
  end
end

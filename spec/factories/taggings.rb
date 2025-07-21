FactoryBot.define do
  factory :tagging do
    # Associates with an existing document and tag
    association :document
    association :tag
  end
end

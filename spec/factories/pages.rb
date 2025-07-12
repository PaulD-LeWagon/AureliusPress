# spec/factories/pages.rb
FactoryBot.define do
  # Inherits all attributes and associations from the :document factory
  # The `type` attribute is set to 'Page' by the :page trait in document factory
  factory :page, parent: :document do
    type { "Page" }
  end
end

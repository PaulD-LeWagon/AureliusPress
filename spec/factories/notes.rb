# spec/factories/notes.rb
FactoryBot.define do
  factory :note, parent: :document do
    type { "Note" }
    # Default visibility specific to Note
    visibility { :private_to_owner }
  end
end

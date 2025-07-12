# spec/factories/journal_entries.rb
FactoryBot.define do
  factory :journal_entry, parent: :document do
    type { "JournalEntry" }
    # Default visibility specific to JournalEntry
    visibility { :private_to_owner }
  end
end

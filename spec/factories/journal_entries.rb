# spec/factories/journal_entries.rb
FactoryBot.define do
  factory :journal_entry, parent: :document, class: JournalEntry do
    type { "JournalEntry" }
    comments_enabled { true }
    # Default visibility specific to JournalEntry
    visibility { :private_to_owner }
  end
end

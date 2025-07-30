# spec/factories/journal_entries.rb
FactoryBot.define do
  factory :aurelius_press_document_journal_entry, parent: :aurelius_press_document_document, class: "AureliusPress::Document::JournalEntry" do
    type { "AureliusPress::Document::JournalEntry" }
    comments_enabled { true }
    # Default visibility specific to JournalEntry
    visibility { :private_to_owner }
  end
end

# spec/models/journal_entry_spec.rb
require "rails_helper"

RSpec.describe JournalEntry, type: :model do
  it "inherits from Document" do
    expect(described_class.superclass).to eq(Document)
  end

  it "sets the correct type for STI" do
    journal_entry = create(:journal_entry)
    expect(journal_entry.type).to eq("JournalEntry")
  end

  it "defaults to private_to_owner visibility" do
    journal_entry = create(:journal_entry)
    expect(journal_entry.visibility).to eq("private_to_owner")
  end
end

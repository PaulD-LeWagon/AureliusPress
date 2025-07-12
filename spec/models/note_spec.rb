# spec/models/note_spec.rb
require "rails_helper"

RSpec.describe Note, type: :model do
  it "inherits from Document" do
    expect(described_class.superclass).to eq(Document)
  end

  it "sets the correct type for STI" do
    note = create(:note)
    expect(note.type).to eq("Note")
  end

  it "defaults to private_to_owner visibility" do
    note = create(:note)
    expect(note.visibility).to eq("private_to_owner")
  end
end

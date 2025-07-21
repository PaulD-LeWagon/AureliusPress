require "rails_helper"

RSpec.describe JournalEntry, type: :model do
  let!(:the_journal_entry) { create(:journal_entry, :with_belt_and_braces) }

  it "is a valid JournalEntry" do
    expect(the_journal_entry).to be_valid
    expect(the_journal_entry).to be_a(JournalEntry)
  end

  it "inherits from Document" do
    expect(described_class.superclass).to eq(Document)
  end

  it "sets the correct type for STI" do
    expect(the_journal_entry.type).to eq("JournalEntry")
  end

  it "has valid attributes" do
    expect(the_journal_entry.title).to be_present
    expect(the_journal_entry.slug).to be_present
    expect(the_journal_entry.subtitle).to be_present
    expect(the_journal_entry.description).to be_present
    expect(the_journal_entry.status).to eq("published")
    expect(the_journal_entry.visibility).to eq("public_to_www")
    expect(the_journal_entry.published_at).to be_present
    expect(the_journal_entry.published_at).to be < Time.current
    expect(the_journal_entry.user).to be_present
    expect(the_journal_entry.user).to be_a(User)
  end

  it "has a valid author (User)" do
    expect(the_journal_entry.user).to be_present
    expect(the_journal_entry.user).to be_valid
    expect(the_journal_entry.user).to be_persisted
    expect(the_journal_entry.user).to be_a(User)
  end

  it "has valid content blocks" do
    expect(the_journal_entry.content_blocks).to be_present
    expect(the_journal_entry.content_blocks.count).to eq(3)
    expect(the_journal_entry.content_blocks.first).to be_a(ContentBlock)
  end

  it "has a valid category" do
    expect(the_journal_entry.category).to be_present
    expect(the_journal_entry.category).to be_a(Category)
  end

  it "has valid tags" do
    expect(the_journal_entry.tags).to be_present
    expect(the_journal_entry.tags.count).to eq(3)
    expect(the_journal_entry.tags.first).to be_a(Tag)
  end

  it "has valid likes" do
    expect(the_journal_entry.likes).to be_present
    expect(the_journal_entry.likes.count).to eq(3)
    expect(the_journal_entry.likes.first).to be_a(Like)
  end

  it "has valid comments" do
    expect(the_journal_entry.comments_enabled).to be true
    expect(the_journal_entry.comments.count).to eq(3)
    the_journal_entry.comments.each do |comment|
      expect(comment).to be_present
      expect(comment).to be_valid
      expect(comment).to be_persisted
      expect(comment).to be_a(Comment)
      comment.replies.each do |reply|
        expect(reply).to be_present
        expect(reply).to be_valid
        expect(reply).to be_persisted
        expect(reply).to be_a(Comment)
        reply.replies.each do |reply_reply|
          expect(reply_reply).to be_present
          expect(reply_reply).to be_valid
          expect(reply_reply).to be_persisted
          expect(reply_reply).to be_a(Comment)
        end
      end
    end
  end
end

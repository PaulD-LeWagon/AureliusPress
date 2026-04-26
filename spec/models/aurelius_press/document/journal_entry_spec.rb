# == Schema Information
#
# Table name: aurelius_press_documents
#
#  id               :bigint           not null, primary key
#  user_id          :bigint           not null
#  category_id      :bigint
#  type             :string           not null
#  slug             :string           not null
#  title            :string           not null
#  subtitle         :string
#  description      :text
#  status           :integer          default("draft"), not null
#  visibility       :integer          default("private_to_owner"), not null
#  published_at     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  comments_enabled :boolean          default(FALSE), not null
#
require "rails_helper"

RSpec.describe AureliusPress::Document::JournalEntry, type: :model do
  subject do
    create(:aurelius_press_document_journal_entry,
           :published_1_month_ago,
           :with_content_blocks,
           :with_category,
           :with_tags,
           :with_3x3x3_comments,
           :with_notes,
           :with_likes,
           subtitle: Faker::Lorem.sentence(word_count: 5),
           description: Faker::Lorem.paragraph(sentence_count: 3),
           comments_enabled: true,
           visibility: :private_to_owner)
  end

  it "is a valid JournalEntry" do
    expect(subject).to be_valid
    expect(subject).to be_a(AureliusPress::Document::JournalEntry)
  end

  it "inherits from Document" do
    expect(described_class.superclass).to eq(AureliusPress::Document::Document)
  end

  it "sets the correct type for STI" do
    expect(subject.type).to eq("AureliusPress::Document::JournalEntry")
  end

  it "has valid attributes" do
    expect(subject.title).to be_present
    expect(subject.slug).to be_present
    expect(subject.subtitle).to be_present
    expect(subject.description).to be_present
    expect(subject.status).to eq("published")
    expect(subject.visibility).to eq("private_to_owner")
    expect(subject.published_at).to be_present
    expect(subject.published_at).to be < Time.current
    expect(subject.user).to be_present
    expect(subject.user).to be_a(AureliusPress::User)
  end

  it "has a valid author (User)" do
    expect(subject.user).to be_present
    expect(subject.user).to be_valid
    expect(subject.user).to be_persisted
    expect(subject.user).to be_a(AureliusPress::User)
  end

  it "has valid content blocks" do
    expect(subject.content_blocks).to be_present
    expect(subject.content_blocks.count).to eq(3)
    expect(subject.content_blocks.first).to be_a(AureliusPress::ContentBlock::ContentBlock)
  end

  it "has valid categories" do
    subject.categories << create(:aurelius_press_taxonomy_category) if subject.categories.empty?
    expect(subject.categories).to be_present
    expect(subject.categories.first).to be_a(AureliusPress::Taxonomy::Category)
  end

  it "has valid tags" do
    expect(subject.tags).to be_present
    expect(subject.tags.count).to eq(3)
    expect(subject.tags.first).to be_a(AureliusPress::Taxonomy::Tag)
  end

  it "has valid likes" do
    expect(subject.likes).to be_present
    expect(subject.likes.count).to eq(3)
    expect(subject.likes.first).to be_a(AureliusPress::Community::Like)
  end

  it "has valid comments" do
    expect(subject.comments_enabled).to be true
    expect(subject.comments.count).to eq(3)
    subject.comments.each do |comment|
      expect(comment).to be_present
      expect(comment).to be_valid
      expect(comment).to be_persisted
      expect(comment).to be_a(AureliusPress::Fragment::Comment)
      comment.replies.each do |reply|
        expect(reply).to be_present
        expect(reply).to be_valid
        expect(reply).to be_persisted
        expect(reply).to be_a(AureliusPress::Fragment::Comment)
        reply.replies.each do |reply_reply|
          expect(reply_reply).to be_present
          expect(reply_reply).to be_valid
          expect(reply_reply).to be_persisted
          expect(reply_reply).to be_a(AureliusPress::Fragment::Comment)
        end
      end
    end
  end
end

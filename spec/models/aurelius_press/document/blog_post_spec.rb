require "rails_helper"
# This file is part of the AureliusPress project.
#
# truncation: true # Use truncation strategy for database cleaning (very time-consuming)
RSpec.describe AureliusPress::Document::BlogPost, type: :model do
  subject { create(:aurelius_press_document_blog_post, :with_belt_and_braces) }

  it "is a valid & persisted BlogPost" do
    expect(subject).to be_valid
    expect(subject).to be_persisted
    expect(subject).to be_a(AureliusPress::Document::BlogPost)
    expect(AureliusPress::Document::BlogPost.find_by(id: subject.id)).to eq(subject)
  end

  it "inherits from Document" do
    expect(described_class.superclass).to eq(AureliusPress::Document::Document)
  end

  it "sets the correct type for STI" do
    expect(subject.type).to eq("AureliusPress::Document::BlogPost")
  end

  it "has valid attributes" do
    expect(subject.title).to be_present
    expect(subject.slug).to be_present
    expect(subject.subtitle).to be_present
    expect(subject.description).to be_present
    expect(subject.status).to eq("published")
    expect(subject.visibility).to eq("public_to_www")
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

  it "has a valid category" do
    expect(subject.category).to be_present
    expect(subject.category).to be_a(AureliusPress::Taxonomy::Category)
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

  it "has valid notes (one for each visibility)" do
    expect(subject.notes.count).to eq(AureliusPress::Document::Document.visibilities.count)
    subject.notes.each do |note|
      expect(note).to be_present
      expect(note).to be_valid
      expect(note).to be_persisted
      expect(note).to be_a(AureliusPress::Fragment::Note)
    end
  end
end

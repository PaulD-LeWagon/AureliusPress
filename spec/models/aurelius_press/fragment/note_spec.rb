# spec/models/note_spec.rb
require "rails_helper"

RSpec.describe AureliusPress::Fragment::Note, type: :model do
  subject { create(:aurelius_press_fragment_note) }

  describe "Note Class" do
    it "has a valid factory" do
      expect(subject).to be_valid
      expect(subject).to be_a(AureliusPress::Fragment::Note)
    end

    it "inherits from Fragment" do
      expect(described_class.superclass).to eq(AureliusPress::Fragment::Fragment)
    end

    it "sets the correct type for STI" do
      expect(subject.type).to eq("AureliusPress::Fragment::Note")
    end
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:notable) }
    it { should have_rich_text(:content) }
    it { should have_many(:comments) }
    it { should have_many(:likes) }
  end

  describe "Validations" do
    it { should validate_presence_of(:type) }
    it { should validate_inclusion_of(:type).in_array(["AureliusPress::Fragment::Note"]) }
    it { should validate_presence_of(:content) }
  end

  describe "Callbacks" do
    it "sets default values on initialization" do
      new_note = create(:aurelius_press_fragment_note)
      expect(new_note.status).to eq("draft")
      expect(new_note.visibility).to eq("private_to_owner")
    end
  end

  describe "Scopes" do
    let!(:blog_post) { create(:aurelius_press_document_blog_post, :with_notes) }
    let!(:notes) { blog_post.notes }
    let!(:user) { blog_post.user }

    it "returns notes visible to owner" do
      expect(AureliusPress::Fragment::Note.visible_to_owner(user)).to include(notes.first)
    end

    it "returns notes visible to group" do
      expect(AureliusPress::Fragment::Note.visible_to_group(user)).to include(notes.second)
    end

    it "returns notes visible to app users" do
      expect(AureliusPress::Fragment::Note.visible_to_app_users(user)).to include(notes.third)
    end

    it "returns notes public to www" do
      expect(AureliusPress::Fragment::Note.public_to_www(user)).to include(notes.fourth)
    end
  end

  describe "Note Attributes" do
    it "has a title" do
      expect(subject.title).to be_present
      expect(subject.title).to be_a(String)
    end

    it "has content" do
      expect(subject.content).to be_present
      expect(subject.content).to be_a(ActionText::RichText)
      expect(subject.content.body.to_plain_text).to be_present
    end
    it "has a user" do
      expect(subject.user).to be_present
      expect(subject.user).to be_a(AureliusPress::User)
    end
    it "has a notable association" do
      expect(subject.notable).to be_present
      expect(subject.notable).to respond_to(:type)
    end
    it "has a position" do
      expect(subject.position).to be_present
      expect(subject.position).to be_a(Integer)
    end
    it "has a type" do
      expect(subject.type).to eq("AureliusPress::Fragment::Note")
    end
    it "has a default status of draft" do
      expect(subject.status).to be_present
      expect(subject.status).to eq("draft")
    end
    it "has a default visibility of private_to_owner" do
      expect(subject.visibility).to be_present
      expect(subject.visibility).to eq("private_to_owner")
    end
  end
end

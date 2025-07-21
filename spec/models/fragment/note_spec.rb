# spec/models/note_spec.rb
require "rails_helper"

RSpec.describe Note, type: :model do
  let!(:note) { create(:note) }

  describe "Note Class" do
    it "has a valid factory" do
      expect(note).to be_valid
      expect(note).to be_a(Note)
    end

    it "inherits from Fragment" do
      expect(described_class.superclass).to eq(Fragment)
    end

    it "sets the correct type for STI" do
      expect(note.type).to eq("Note")
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
    it { should validate_inclusion_of(:type).in_array(["Note"]) }
    it { should validate_presence_of(:content) }
  end

  describe "Callbacks" do
    it "sets default values on initialization" do
      new_note = create(:note)
      expect(new_note.status).to eq("draft")
      expect(new_note.visibility).to eq("private_to_owner")
    end
  end

  describe "Scopes" do
    let!(:blog_post) { create(:blog_post, :with_notes) }
    let!(:notes) { blog_post.notes }
    let!(:user) { blog_post.user }

    it "returns notes visible to owner" do
      expect(Note.visible_to_owner(user)).to include(notes.first)
    end

    it "returns notes visible to group" do
      expect(Note.visible_to_group(user)).to include(notes.second)
    end

    it "returns notes visible to app users" do
      expect(Note.visible_to_app_users(user)).to include(notes.third)
    end

    it "returns notes public to www" do
      expect(Note.public_to_www(user)).to include(notes.fourth)
    end
  end

  describe "Note Attributes" do
    it "has a title" do
      expect(note.title).to be_present
      expect(note.title).to be_a(String)
    end

    it "has content" do
      expect(note.content).to be_present
      expect(note.content).to be_a(ActionText::RichText)
      expect(note.content.body.to_plain_text).to be_present
    end
    it "has a user" do
      expect(note.user).to be_present
      expect(note.user).to be_a(User)
    end
    it "has a notable association" do
      expect(note.notable).to be_present
      expect(note.notable).to respond_to(:type)
    end
    it "has a position" do
      expect(note.position).to be_present
      expect(note.position).to be_a(Integer)
    end
    it "has a type" do
      expect(note.type).to eq("Note")
    end
    it "has a default status of draft" do
      expect(note.status).to be_present
      expect(note.status).to eq("draft")
    end
    it "has a default visibility of private_to_owner" do
      expect(note.visibility).to be_present
      expect(note.visibility).to eq("private_to_owner")
    end
  end
end

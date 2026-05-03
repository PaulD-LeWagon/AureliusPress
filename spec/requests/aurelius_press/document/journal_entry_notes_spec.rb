require "rails_helper"

RSpec.describe "AureliusPress::Document::JournalEntry Notes", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:journal_entry) { create(:aurelius_press_document_journal_entry, user: owner) }
  let(:valid_params) { { note: { title: "A private thought", content: "Note body." } } }

  describe "POST /aurelius-press/journal-entries/:journal_entry_id/notes" do
    context "when authenticated as the journal entry owner" do
      before { sign_in owner }

      it "creates a note on the journal entry" do
        expect {
          post aurelius_press_journal_entry_notes_path(journal_entry), params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end

      it "associates the note with the current user" do
        post aurelius_press_journal_entry_notes_path(journal_entry), params: valid_params
        expect(AureliusPress::Fragment::Note.last.user).to eq(owner)
      end

      it "associates the note with the journal entry" do
        post aurelius_press_journal_entry_notes_path(journal_entry), params: valid_params
        expect(AureliusPress::Fragment::Note.last.notable).to eq(journal_entry)
      end

      it "returns turbo stream or redirect success" do
        post aurelius_press_journal_entry_notes_path(journal_entry), params: valid_params
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not create a note (journal is private)" do
        expect {
          post aurelius_press_journal_entry_notes_path(journal_entry), params: valid_params
        }.not_to change(AureliusPress::Fragment::Note, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_journal_entry_notes_path(journal_entry), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/journal-entries/:journal_entry_id/notes/:id" do
    let!(:note) { create(:aurelius_press_fragment_note, user: owner, notable: journal_entry) }

    context "when authenticated as the note owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_journal_entry_note_path(journal_entry, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end

      it "returns turbo stream or redirect success" do
        delete aurelius_press_journal_entry_note_path(journal_entry, note)
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the note" do
        expect {
          delete aurelius_press_journal_entry_note_path(journal_entry, note)
        }.not_to change(AureliusPress::Fragment::Note, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_journal_entry_note_path(journal_entry, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /aurelius-press/journal-entries/:journal_entry_id/notes/:id" do
    let!(:note) { create(:aurelius_press_fragment_note, user: owner, notable: journal_entry) }

    context "when authenticated as the note owner" do
      before { sign_in owner }

      it "updates the note" do
        patch aurelius_press_journal_entry_note_path(journal_entry, note),
              params: { note: { content: "Updated content." } }
        expect(note.reload.content.to_plain_text).to eq("Updated content.")
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        patch aurelius_press_journal_entry_note_path(journal_entry, note),
              params: { note: { content: "Attempt." } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

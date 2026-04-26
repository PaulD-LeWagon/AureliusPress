require "rails_helper"

RSpec.describe "AureliusPress::Catalogue::Notes", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:valid_params) { { note: { title: "My note", content: "Note body." } } }

  # ── Author parent ──────────────────────────────────────────────────────────

  describe "POST /aurelius-press/catalogue/authors/:author_slug/notes" do
    let(:author) { create(:aurelius_press_catalogue_author) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a note on the author" do
        expect {
          post aurelius_press_catalogue_author_notes_path(author), params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end

      it "associates the note with the current user" do
        post aurelius_press_catalogue_author_notes_path(author), params: valid_params
        expect(AureliusPress::Fragment::Note.last.user).to eq(owner)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_catalogue_author_notes_path(author), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/catalogue/authors/:author_slug/notes/:id" do
    let(:author)  { create(:aurelius_press_catalogue_author) }
    let!(:note)   { create(:aurelius_press_fragment_note, user: owner, notable: author) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_catalogue_author_note_path(author, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the note" do
        expect {
          delete aurelius_press_catalogue_author_note_path(author, note)
        }.not_to change(AureliusPress::Fragment::Note, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_catalogue_author_note_path(author, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── Source parent ──────────────────────────────────────────────────────────

  describe "POST /aurelius-press/catalogue/sources/:source_slug/notes" do
    let(:source) { create(:aurelius_press_catalogue_source) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a note on the source" do
        expect {
          post aurelius_press_catalogue_source_notes_path(source), params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_catalogue_source_notes_path(source), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/catalogue/sources/:source_slug/notes/:id" do
    let(:source) { create(:aurelius_press_catalogue_source) }
    let!(:note)  { create(:aurelius_press_fragment_note, user: owner, notable: source) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_catalogue_source_note_path(source, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_catalogue_source_note_path(source, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── Quote parent ───────────────────────────────────────────────────────────

  describe "POST /aurelius-press/catalogue/quotes/:quote_slug/notes" do
    let(:quote) { create(:aurelius_press_catalogue_quote) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a note on the quote" do
        expect {
          post aurelius_press_catalogue_quote_notes_path(quote), params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_catalogue_quote_notes_path(quote), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/catalogue/quotes/:quote_slug/notes/:id" do
    let(:quote) { create(:aurelius_press_catalogue_quote) }
    let!(:note) { create(:aurelius_press_fragment_note, user: owner, notable: quote) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_catalogue_quote_note_path(quote, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_catalogue_quote_note_path(quote, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

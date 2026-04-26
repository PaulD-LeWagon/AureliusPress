require "rails_helper"

RSpec.describe "AureliusPress::Document::JournalEntries", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let!(:entry)     { create(:aurelius_press_document_journal_entry, user: owner) }
  let(:valid_params) do
    { aurelius_press_document_journal_entry: { title: "My private thoughts", description: "Some content." } }
  end

  # ── Authentication gate ────────────────────────────────────────────────────

  describe "GET /aurelius-press/journal-entries (index)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        get aurelius_press_journal_entries_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as owner" do
      before { sign_in owner }

      it "returns http success" do
        get aurelius_press_journal_entries_path
        expect(response).to have_http_status(:success)
      end

      it "only shows own entries" do
        other_entry = create(:aurelius_press_document_journal_entry, user: other_user)
        get aurelius_press_journal_entries_path
        expect(response.body).to include(entry.title)
        expect(response.body).not_to include(other_entry.title)
      end
    end
  end

  # ── Show ───────────────────────────────────────────────────────────────────

  describe "GET /aurelius-press/journal-entries/:id (show)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        get aurelius_press_journal_entry_path(entry)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as owner" do
      before { sign_in owner }

      it "returns http success" do
        get aurelius_press_journal_entry_path(entry)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not return the entry (forbidden or redirect)" do
        get aurelius_press_journal_entry_path(entry)
        expect(response).not_to have_http_status(:success)
      end
    end
  end

  # ── New / Create ───────────────────────────────────────────────────────────

  describe "GET /aurelius-press/journal-entries/new (new)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        get new_aurelius_press_journal_entry_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in owner }

      it "returns http success" do
        get new_aurelius_press_journal_entry_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST /aurelius-press/journal-entries (create)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_journal_entries_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated" do
      before { sign_in owner }

      it "creates a new journal entry" do
        expect {
          post aurelius_press_journal_entries_path, params: valid_params
        }.to change(AureliusPress::Document::JournalEntry, :count).by(1)
      end

      it "sets the entry owner to current_user" do
        post aurelius_press_journal_entries_path, params: valid_params
        expect(AureliusPress::Document::JournalEntry.last.user).to eq(owner)
      end

      it "enforces private_to_owner visibility regardless of submitted params" do
        params_with_public = valid_params.deep_merge(
          aurelius_press_document_journal_entry: { visibility: :public_to_www }
        )
        post aurelius_press_journal_entries_path, params: params_with_public
        expect(AureliusPress::Document::JournalEntry.last.visibility).to eq("private_to_owner")
      end

      it "redirects to the created entry" do
        post aurelius_press_journal_entries_path, params: valid_params
        expect(response).to redirect_to(aurelius_press_journal_entry_path(AureliusPress::Document::JournalEntry.last))
      end
    end
  end

  # ── Edit / Update ──────────────────────────────────────────────────────────

  describe "GET /aurelius-press/journal-entries/:id/edit (edit)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        get edit_aurelius_press_journal_entry_path(entry)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as owner" do
      before { sign_in owner }

      it "returns http success" do
        get edit_aurelius_press_journal_entry_path(entry)
        expect(response).to have_http_status(:success)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "is forbidden" do
        get edit_aurelius_press_journal_entry_path(entry)
        expect(response).not_to have_http_status(:success)
      end
    end
  end

  describe "PATCH /aurelius-press/journal-entries/:id (update)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        patch aurelius_press_journal_entry_path(entry),
              params: { aurelius_press_document_journal_entry: { title: "Updated" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as owner" do
      before { sign_in owner }

      it "updates the entry" do
        patch aurelius_press_journal_entry_path(entry),
              params: { aurelius_press_document_journal_entry: { title: "Updated Title" } }
        expect(entry.reload.title).to eq("Updated Title")
      end

      it "redirects to the entry" do
        patch aurelius_press_journal_entry_path(entry),
              params: { aurelius_press_document_journal_entry: { title: "Updated Title" } }
        expect(response).to redirect_to(aurelius_press_journal_entry_path(entry.reload))
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "is forbidden" do
        patch aurelius_press_journal_entry_path(entry),
              params: { aurelius_press_document_journal_entry: { title: "Hijacked" } }
        expect(response).not_to have_http_status(:success)
        expect(entry.reload.title).not_to eq("Hijacked")
      end
    end
  end

  # ── Destroy ────────────────────────────────────────────────────────────────

  describe "DELETE /aurelius-press/journal-entries/:id (destroy)" do
    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_journal_entry_path(entry)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the entry" do
        expect {
          delete aurelius_press_journal_entry_path(entry)
        }.to change(AureliusPress::Document::JournalEntry, :count).by(-1)
      end

      it "redirects to the index" do
        delete aurelius_press_journal_entry_path(entry)
        expect(response).to redirect_to(aurelius_press_journal_entries_path)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the entry" do
        expect {
          delete aurelius_press_journal_entry_path(entry)
        }.not_to change(AureliusPress::Document::JournalEntry, :count)
      end
    end
  end
end

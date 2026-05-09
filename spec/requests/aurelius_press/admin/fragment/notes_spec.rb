require "rails_helper"

RSpec.describe "AureliusPress::Admin::Fragment::Notes", type: :request do
  let(:admin) { create(:aurelius_press_admin_user) }
  let(:user)  { create(:aurelius_press_user) }
  let(:note)  { create(:aurelius_press_fragment_note) }

  let(:turbo_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  describe "GET /aurelius-press/admin/fragment/notes" do
    before { sign_in admin }

    it "returns http success" do
      get aurelius_press_admin_fragment_notes_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /aurelius-press/admin/fragment/notes/:id" do
    before { sign_in admin }

    it "returns http success" do
      get aurelius_press_admin_fragment_note_path(note)
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE /aurelius-press/admin/fragment/notes/:id" do
    context "when authenticated as admin" do
      before { sign_in admin }

      it "discards the note" do
        note
        expect {
          delete aurelius_press_admin_fragment_note_path(note), headers: turbo_headers
        }.to change { AureliusPress::Fragment::Note.kept.count }.by(-1)
      end

      it "responds with turbo_stream media type" do
        delete aurelius_press_admin_fragment_note_path(note), headers: turbo_headers
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "returns http success" do
        delete aurelius_press_admin_fragment_note_path(note), headers: turbo_headers
        expect(response).to have_http_status(:ok)
      end

      it "falls back to html redirect" do
        delete aurelius_press_admin_fragment_note_path(note)
        expect(response).to redirect_to(aurelius_press_admin_fragment_notes_path)
      end
    end

    context "when authenticated as non-admin" do
      before { sign_in user }

      it "redirects to root" do
        delete aurelius_press_admin_fragment_note_path(note), headers: turbo_headers
        expect(response).to redirect_to(root_path)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_admin_fragment_note_path(note), headers: turbo_headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

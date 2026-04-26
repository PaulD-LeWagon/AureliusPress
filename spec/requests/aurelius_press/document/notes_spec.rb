require "rails_helper"

RSpec.describe "AureliusPress::Document::Notes", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:valid_params) { { note: { title: "My note", content: "Note body." } } }

  # ── BlogPost parent ────────────────────────────────────────────────────────

  describe "POST /aurelius-press/blog-posts/:blog_post_id/notes" do
    let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a note on the blog post" do
        expect {
          post aurelius_press_blog_post_notes_path(blog_post), params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end

      it "associates the note with the current user" do
        post aurelius_press_blog_post_notes_path(blog_post), params: valid_params
        expect(AureliusPress::Fragment::Note.last.user).to eq(owner)
      end

      it "redirects or returns turbo stream success" do
        post aurelius_press_blog_post_notes_path(blog_post), params: valid_params
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_blog_post_notes_path(blog_post), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/blog-posts/:blog_post_id/notes/:id" do
    let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }
    let!(:note) { create(:aurelius_press_fragment_note, user: owner, notable: blog_post) }

    context "when authenticated as the note owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_blog_post_note_path(blog_post, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end

      it "redirects or returns turbo stream success" do
        delete aurelius_press_blog_post_note_path(blog_post, note)
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the note" do
        expect {
          delete aurelius_press_blog_post_note_path(blog_post, note)
        }.not_to change(AureliusPress::Fragment::Note, :count)
      end

      it "returns forbidden or redirects" do
        delete aurelius_press_blog_post_note_path(blog_post, note)
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_blog_post_note_path(blog_post, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── AtomicBlogPost parent ──────────────────────────────────────────────────

  describe "POST /aurelius-press/atomic-blog-posts/:atomic_blog_post_id/notes" do
    let(:atomic_blog_post) { create(:aurelius_press_document_atomic_blog_post, :visible_to_www) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a note on the atomic blog post" do
        expect {
          post aurelius_press_atomic_blog_post_notes_path(atomic_blog_post), params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end

      it "associates the note with the current user" do
        post aurelius_press_atomic_blog_post_notes_path(atomic_blog_post), params: valid_params
        expect(AureliusPress::Fragment::Note.last.user).to eq(owner)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_atomic_blog_post_notes_path(atomic_blog_post), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/atomic-blog-posts/:atomic_blog_post_id/notes/:id" do
    let(:atomic_blog_post) { create(:aurelius_press_document_atomic_blog_post, :visible_to_www) }
    let!(:note) { create(:aurelius_press_fragment_note, user: owner, notable: atomic_blog_post) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_atomic_blog_post_note_path(atomic_blog_post, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_atomic_blog_post_note_path(atomic_blog_post, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── Page parent ────────────────────────────────────────────────────────────

  describe "POST /aurelius-press/pages/:page_id/notes" do
    let(:page) { create(:aurelius_press_document_page, :visible_to_www) }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a note on the page" do
        expect {
          post aurelius_press_page_notes_path(page), params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end

      it "associates the note with the current user" do
        post aurelius_press_page_notes_path(page), params: valid_params
        expect(AureliusPress::Fragment::Note.last.user).to eq(owner)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_page_notes_path(page), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/pages/:page_id/notes/:id" do
    let(:page) { create(:aurelius_press_document_page, :visible_to_www) }
    let!(:note) { create(:aurelius_press_fragment_note, user: owner, notable: page) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_page_note_path(page, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_page_note_path(page, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

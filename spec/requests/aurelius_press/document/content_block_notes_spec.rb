require "rails_helper"

RSpec.describe "AureliusPress::Document::ContentBlock Notes", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }
  let(:blog_post)  { create(:aurelius_press_document_blog_post, :visible_to_www) }
  let(:rich_text_block) do
    create(:aurelius_press_content_block_rich_text_block, :attached_to_a, document_obj: blog_post)
  end
  let(:content_block) { rich_text_block.content_block }
  let(:valid_params)  { { note: { title: "My note", content: "Note body." } } }

  # ── POST /aurelius-press/blog-posts/:blog_post_id/cb/:content_block_id/notes ──

  describe "POST /.../blog-posts/:blog_post_id/cb/:content_block_id/notes" do
    context "when authenticated" do
      before { sign_in owner }

      it "creates a note on the content block" do
        expect {
          post aurelius_press_blog_post_content_block_notes_path(blog_post, content_block),
               params: valid_params
        }.to change(AureliusPress::Fragment::Note, :count).by(1)
      end

      it "associates the note with the current user" do
        post aurelius_press_blog_post_content_block_notes_path(blog_post, content_block),
             params: valid_params
        expect(AureliusPress::Fragment::Note.last.user).to eq(owner)
      end

      it "associates the note with the content block" do
        post aurelius_press_blog_post_content_block_notes_path(blog_post, content_block),
             params: valid_params
        expect(AureliusPress::Fragment::Note.last.notable).to eq(content_block)
      end

      it "redirects or returns turbo stream success" do
        post aurelius_press_blog_post_content_block_notes_path(blog_post, content_block),
             params: valid_params
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_blog_post_content_block_notes_path(blog_post, content_block),
             params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── DELETE /.../blog-posts/:blog_post_id/cb/:content_block_id/notes/:id ──

  describe "DELETE /.../blog-posts/:blog_post_id/cb/:content_block_id/notes/:id" do
    let!(:note) { create(:aurelius_press_fragment_note, user: owner, notable: content_block) }

    context "when authenticated as the note owner" do
      before { sign_in owner }

      it "destroys the note" do
        expect {
          delete aurelius_press_blog_post_content_block_note_path(blog_post, content_block, note)
        }.to change(AureliusPress::Fragment::Note, :count).by(-1)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the note" do
        expect {
          delete aurelius_press_blog_post_content_block_note_path(blog_post, content_block, note)
        }.not_to change(AureliusPress::Fragment::Note, :count)
      end

      it "returns forbidden or redirects" do
        delete aurelius_press_blog_post_content_block_note_path(blog_post, content_block, note)
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_blog_post_content_block_note_path(blog_post, content_block, note)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

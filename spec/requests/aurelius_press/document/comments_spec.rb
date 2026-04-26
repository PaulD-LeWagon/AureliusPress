require "rails_helper"

RSpec.describe "AureliusPress::Document::Comments", type: :request do
  let(:owner)      { create(:aurelius_press_user) }
  let(:other_user) { create(:aurelius_press_user) }

  # ── BlogPost parent ────────────────────────────────────────────────────────

  describe "POST /aurelius-press/blog-posts/:blog_post_id/comments" do
    let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }
    let(:valid_params) { { comment: { content: "A thoughtful comment." } } }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a comment on the blog post" do
        expect {
          post aurelius_press_blog_post_comments_path(blog_post), params: valid_params
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
      end

      it "associates the comment with the current user" do
        post aurelius_press_blog_post_comments_path(blog_post), params: valid_params
        expect(AureliusPress::Fragment::Comment.last.user).to eq(owner)
      end

      it "redirects or returns turbo stream success" do
        post aurelius_press_blog_post_comments_path(blog_post), params: valid_params
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_blog_post_comments_path(blog_post), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/blog-posts/:blog_post_id/comments/:id" do
    let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }
    let!(:comment)  { create(:aurelius_press_fragment_comment, :on_blog_post, user: owner, commentable: blog_post) }

    context "when authenticated as the comment owner" do
      before { sign_in owner }

      it "destroys the comment" do
        expect {
          delete aurelius_press_blog_post_comment_path(blog_post, comment)
        }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
      end

      it "redirects or returns turbo stream success" do
        delete aurelius_press_blog_post_comment_path(blog_post, comment)
        expect(response).to have_http_status(:redirect).or have_http_status(:ok)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the comment" do
        expect {
          delete aurelius_press_blog_post_comment_path(blog_post, comment)
        }.not_to change(AureliusPress::Fragment::Comment, :count)
      end

      it "returns forbidden or redirects" do
        delete aurelius_press_blog_post_comment_path(blog_post, comment)
        expect(response).to have_http_status(:forbidden).or have_http_status(:redirect)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_blog_post_comment_path(blog_post, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── AtomicBlogPost parent ──────────────────────────────────────────────────

  describe "POST /aurelius-press/atomic-blog-posts/:atomic_blog_post_id/comments" do
    let(:atomic_blog_post) { create(:aurelius_press_document_atomic_blog_post, :visible_to_www) }
    let(:valid_params) { { comment: { content: "A thoughtful comment." } } }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a comment on the atomic blog post" do
        expect {
          post aurelius_press_atomic_blog_post_comments_path(atomic_blog_post), params: valid_params
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
      end

      it "associates the comment with the current user" do
        post aurelius_press_atomic_blog_post_comments_path(atomic_blog_post), params: valid_params
        expect(AureliusPress::Fragment::Comment.last.user).to eq(owner)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_atomic_blog_post_comments_path(atomic_blog_post), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/atomic-blog-posts/:atomic_blog_post_id/comments/:id" do
    let(:atomic_blog_post) { create(:aurelius_press_document_atomic_blog_post, :visible_to_www) }
    let!(:comment) { create(:aurelius_press_fragment_comment, :on_atomic_blog_post, user: owner, commentable: atomic_blog_post) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the comment" do
        expect {
          delete aurelius_press_atomic_blog_post_comment_path(atomic_blog_post, comment)
        }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_atomic_blog_post_comment_path(atomic_blog_post, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── Page parent (S2-03) ────────────────────────────────────────────────────

  describe "POST /aurelius-press/pages/:page_id/comments" do
    let(:page) { create(:aurelius_press_document_page, :visible_to_www) }
    let(:valid_params) { { comment: { content: "A thoughtful comment." } } }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a comment on the page" do
        expect {
          post aurelius_press_page_comments_path(page), params: valid_params
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
      end

      it "associates the comment with the current user" do
        post aurelius_press_page_comments_path(page), params: valid_params
        expect(AureliusPress::Fragment::Comment.last.user).to eq(owner)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_page_comments_path(page), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /aurelius-press/pages/:page_id/comments/:id" do
    let(:page) { create(:aurelius_press_document_page, :visible_to_www) }
    let!(:comment) { create(:aurelius_press_fragment_comment, :on_page, user: owner, commentable: page) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the comment" do
        expect {
          delete aurelius_press_page_comment_path(page, comment)
        }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
      end
    end

    context "when authenticated as a different user" do
      before { sign_in other_user }

      it "does not destroy the comment" do
        expect {
          delete aurelius_press_page_comment_path(page, comment)
        }.not_to change(AureliusPress::Fragment::Comment, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_page_comment_path(page, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # ── ContentBlock parent (S2-09) ────────────────────────────────────────────

  describe "POST /.../cb/:content_block_id/comments" do
    let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www) }
    let(:rich_text_block) do
      create(:aurelius_press_content_block_rich_text_block, :attached_to_a, document_obj: blog_post)
    end
    let(:content_block) { rich_text_block.content_block }
    let(:valid_params)  { { comment: { content: "A comment on a content block." } } }

    context "when authenticated" do
      before { sign_in owner }

      it "creates a comment on the content block" do
        expect {
          post aurelius_press_blog_post_content_block_comments_path(blog_post, content_block),
               params: valid_params
        }.to change(AureliusPress::Fragment::Comment, :count).by(1)
      end

      it "associates the comment with the content block" do
        post aurelius_press_blog_post_content_block_comments_path(blog_post, content_block),
             params: valid_params
        expect(AureliusPress::Fragment::Comment.last.commentable).to eq(content_block)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        post aurelius_press_blog_post_content_block_comments_path(blog_post, content_block),
             params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /.../cb/:content_block_id/comments/:id" do
    let(:blog_post)      { create(:aurelius_press_document_blog_post, :visible_to_www) }
    let(:rich_text_block) do
      create(:aurelius_press_content_block_rich_text_block, :attached_to_a, document_obj: blog_post)
    end
    let(:content_block) { rich_text_block.content_block }
    let!(:comment) { create(:aurelius_press_fragment_comment, user: owner, commentable: content_block) }

    context "when authenticated as owner" do
      before { sign_in owner }

      it "destroys the comment" do
        expect {
          delete aurelius_press_blog_post_content_block_comment_path(blog_post, content_block, comment)
        }.to change(AureliusPress::Fragment::Comment, :count).by(-1)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_blog_post_content_block_comment_path(blog_post, content_block, comment)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end

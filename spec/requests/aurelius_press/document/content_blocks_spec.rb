require "rails_helper"

RSpec.describe "Document::ContentBlocks", type: :request do
  let(:owner)     { create(:aurelius_press_user) }
  let(:other)     { create(:aurelius_press_user) }
  let(:blog_post) { create(:aurelius_press_document_blog_post, :visible_to_www, user: owner) }
  let(:page_doc)  { create(:aurelius_press_document_page, :visible_to_www, user: owner) }
  let!(:cb_on_post) do
    create(:aurelius_press_content_block_content_block, :as_rich_text_block, document: blog_post)
  end
  let!(:cb_on_page) do
    create(:aurelius_press_content_block_content_block, :as_rich_text_block, document: page_doc)
  end

  let(:turbo_headers) { { "Accept" => "text/vnd.turbo-stream.html" } }

  describe "DELETE /blog-posts/:blog_post_id/cb/:id" do
    context "when authenticated as document owner" do
      before { sign_in owner }

      it "destroys the content block" do
        expect {
          delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post),
                 headers: turbo_headers
        }.to change(AureliusPress::ContentBlock::ContentBlock, :count).by(-1)
      end

      it "responds with turbo_stream media type" do
        delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post),
               headers: turbo_headers
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "returns http success" do
        delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post),
               headers: turbo_headers
        expect(response).to have_http_status(:ok)
      end

      it "falls back to html redirect" do
        delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post)
        expect(response).to redirect_to(edit_aurelius_press_blog_post_path(blog_post))
      end
    end

    context "when authenticated as a non-owner" do
      before { sign_in other }

      it "redirects to root (Pundit not-authorized)" do
        delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post),
               headers: turbo_headers
        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the content block" do
        expect {
          delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post),
                 headers: turbo_headers
        }.not_to change(AureliusPress::ContentBlock::ContentBlock, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post),
               headers: turbo_headers
        expect(response).to redirect_to(new_user_session_path)
      end

      it "does not destroy the content block" do
        expect {
          delete aurelius_press_blog_post_content_block_path(blog_post, cb_on_post),
                 headers: turbo_headers
        }.not_to change(AureliusPress::ContentBlock::ContentBlock, :count)
      end
    end
  end

  describe "DELETE /pages/:page_id/cb/:id" do
    context "when authenticated as document owner" do
      before { sign_in owner }

      it "destroys the content block" do
        expect {
          delete aurelius_press_page_content_block_path(page_doc, cb_on_page),
                 headers: turbo_headers
        }.to change(AureliusPress::ContentBlock::ContentBlock, :count).by(-1)
      end

      it "responds with turbo_stream media type" do
        delete aurelius_press_page_content_block_path(page_doc, cb_on_page),
               headers: turbo_headers
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end

      it "falls back to html redirect" do
        delete aurelius_press_page_content_block_path(page_doc, cb_on_page)
        expect(response).to redirect_to(edit_aurelius_press_page_path(page_doc))
      end
    end

    context "when authenticated as a non-owner" do
      before { sign_in other }

      it "redirects to root (Pundit not-authorized)" do
        delete aurelius_press_page_content_block_path(page_doc, cb_on_page),
               headers: turbo_headers
        expect(response).to redirect_to(root_path)
      end

      it "does not destroy the content block" do
        expect {
          delete aurelius_press_page_content_block_path(page_doc, cb_on_page),
                 headers: turbo_headers
        }.not_to change(AureliusPress::ContentBlock::ContentBlock, :count)
      end
    end

    context "when unauthenticated" do
      it "redirects to sign in" do
        delete aurelius_press_page_content_block_path(page_doc, cb_on_page),
               headers: turbo_headers
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

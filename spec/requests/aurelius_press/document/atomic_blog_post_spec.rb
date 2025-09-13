require "rails_helper"

RSpec.describe AureliusPress::Document::AtomicBlogPost, type: :request do
  let!(:aurelius_press_atomic_blog_post) { create(:aurelius_press_document_atomic_blog_post) }

  before do
    sign_in create(:aurelius_press_admin_user)
  end

  describe "GET /atomic-blog-posts/index" do
    it "returns http success" do
      get aurelius_press_atomic_blog_posts_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /atomic-blog-posts/show" do
    it "returns http success" do
      get aurelius_press_atomic_blog_post_path(aurelius_press_atomic_blog_post)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /atomic-blog-posts/new" do
    it "returns http success" do
      get new_aurelius_press_atomic_blog_post_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "POST /atomic-blog-posts/create" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for(:aurelius_press_document_atomic_blog_post, user_id: create(:aurelius_press_admin_user).id) }

      it "creates a new atomic blog post" do
        expect {
          post aurelius_press_atomic_blog_posts_path, params: { aurelius_press_document_atomic_blog_post: valid_attributes }
        }.to change(AureliusPress::Document::AtomicBlogPost, :count).by(1)
      end

      it "redirects to the created atomic blog post" do
        post aurelius_press_atomic_blog_posts_path, params: { aurelius_press_document_atomic_blog_post: valid_attributes }
        expect(response).to redirect_to(aurelius_press_atomic_blog_post_path(AureliusPress::Document::AtomicBlogPost.last))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /atomic-blog-posts/:slug/edit" do
    it "returns http success" do
      get edit_aurelius_press_atomic_blog_post_path(aurelius_press_atomic_blog_post)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "PATCH /atomic-blog-posts/:slug" do
    context "with valid parameters" do
      let(:new_attributes) { { title: "The New Title" } }

      it "updates the requested atomic blog post" do
        patch aurelius_press_atomic_blog_post_path(aurelius_press_atomic_blog_post), params: { aurelius_press_document_atomic_blog_post: new_attributes }
        aurelius_press_atomic_blog_post.reload
        expect(aurelius_press_atomic_blog_post.title).to eq("The New Title")
      end

      it "redirects to the atomic blog post" do
        patch aurelius_press_atomic_blog_post_path(aurelius_press_atomic_blog_post), params: { aurelius_press_document_atomic_blog_post: new_attributes }
        aurelius_press_atomic_blog_post.reload
        expect(response).to redirect_to(aurelius_press_atomic_blog_post_path(aurelius_press_atomic_blog_post))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "DELETE /atomic-blog-posts/:slug" do
    it "destroys the requested atomic blog post" do
      expect {
        delete aurelius_press_atomic_blog_post_path(aurelius_press_atomic_blog_post)
      }.to change(AureliusPress::Document::AtomicBlogPost, :count).by(-1)
    end

    it "redirects to the atomic blog posts list" do
      delete aurelius_press_atomic_blog_post_path(aurelius_press_atomic_blog_post)
      expect(response).to redirect_to(aurelius_press_atomic_blog_posts_path)
    end
  end
end

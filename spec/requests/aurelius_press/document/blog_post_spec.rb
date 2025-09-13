require "rails_helper"

RSpec.describe AureliusPress::Document::BlogPost, type: :request do
  let!(:aurelius_press_blog_post) { create(:aurelius_press_document_blog_post) }

  before do
    sign_in create(:aurelius_press_admin_user)
  end

  describe "GET /blog-posts/index" do
    it "returns http success" do
      get aurelius_press_blog_posts_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /blog-posts/show" do
    it "returns http success" do
      get aurelius_press_blog_post_path(aurelius_press_blog_post)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /blog-posts/new" do
    it "returns http success" do
      get new_aurelius_press_blog_post_path
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "POST /blog-posts/create" do
    context "with valid parameters" do
      let(:valid_attributes) { attributes_for(:aurelius_press_document_blog_post, user_id: create(:aurelius_press_admin_user).id) }

      it "creates a new blog post" do
        expect {
          post aurelius_press_blog_posts_path, params: { aurelius_press_document_blog_post: valid_attributes }
        }.to change(AureliusPress::Document::BlogPost, :count).by(1)
      end

      it "redirects to the created blog post" do
        post aurelius_press_blog_posts_path, params: { aurelius_press_document_blog_post: valid_attributes }
        expect(response).to redirect_to(aurelius_press_blog_post_path(AureliusPress::Document::BlogPost.last))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "GET /blog-posts/:slug/edit" do
    it "returns http success" do
      get edit_aurelius_press_blog_post_path(aurelius_press_blog_post)
      expect(response).to have_http_status(:success)
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "PATCH /blog-posts/:slug" do
    context "with valid parameters" do
      let(:new_attributes) { { title: "The New Title" } }

      it "updates the requested blog post" do
        patch aurelius_press_blog_post_path(aurelius_press_blog_post), params: { aurelius_press_document_blog_post: new_attributes }
        aurelius_press_blog_post.reload
        expect(aurelius_press_blog_post.title).to eq("The New Title")
      end

      it "redirects to the blog post" do
        patch aurelius_press_blog_post_path(aurelius_press_blog_post), params: { aurelius_press_document_blog_post: new_attributes }
        aurelius_press_blog_post.reload
        expect(response).to redirect_to(aurelius_press_blog_post_path(aurelius_press_blog_post))
      end
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------------

  describe "DELETE /blog-posts/:slug" do
    it "destroys the requested blog post" do
      expect {
        delete aurelius_press_blog_post_path(aurelius_press_blog_post)
      }.to change(AureliusPress::Document::BlogPost, :count).by(-1)
    end

    it "redirects to the blog posts list" do
      delete aurelius_press_blog_post_path(aurelius_press_blog_post)
      expect(response).to redirect_to(aurelius_press_blog_posts_path)
    end
  end
end

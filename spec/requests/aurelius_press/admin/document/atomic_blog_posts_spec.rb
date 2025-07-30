require 'rails_helper'

RSpec.describe "AureliusPress::Admin::Document::AtomicBlogPosts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/admin/document/atomic_blog_posts/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/admin/document/atomic_blog_posts/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/aurelius_press/admin/document/atomic_blog_posts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/aurelius_press/admin/document/atomic_blog_posts/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/aurelius_press/admin/document/atomic_blog_posts/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/aurelius_press/admin/document/atomic_blog_posts/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/aurelius_press/admin/document/atomic_blog_posts/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

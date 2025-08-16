require 'rails_helper'

RSpec.describe "AureliusPress::Admin::ContentBlock::GalleryBlocks", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/admin/content_block/gallery_blocks/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/admin/content_block/gallery_blocks/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/aurelius_press/admin/content_block/gallery_blocks/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/aurelius_press/admin/content_block/gallery_blocks/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/aurelius_press/admin/content_block/gallery_blocks/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/aurelius_press/admin/content_block/gallery_blocks/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/aurelius_press/admin/content_block/gallery_blocks/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

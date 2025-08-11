require 'rails_helper'

RSpec.describe "AureliusPress::Document::Pages", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/document/pages/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/document/pages/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/aurelius_press/document/pages/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/aurelius_press/document/pages/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/aurelius_press/document/pages/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/aurelius_press/document/pages/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/aurelius_press/document/pages/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

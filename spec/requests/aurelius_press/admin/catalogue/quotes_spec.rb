require 'rails_helper'

RSpec.describe "AureliusPress::Admin::Catalogue::Quotes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/admin/catalogue/quotes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/admin/catalogue/quotes/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/aurelius_press/admin/catalogue/quotes/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/aurelius_press/admin/catalogue/quotes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/aurelius_press/admin/catalogue/quotes/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/aurelius_press/admin/catalogue/quotes/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/aurelius_press/admin/catalogue/quotes/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

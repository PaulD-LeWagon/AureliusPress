require 'rails_helper'

RSpec.describe "AureliusPress::Admin::Fragment::Notes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/admin/fragment/notes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/admin/fragment/notes/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/aurelius_press/admin/fragment/notes/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/aurelius_press/admin/fragment/notes/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/aurelius_press/admin/fragment/notes/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/aurelius_press/admin/fragment/notes/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/aurelius_press/admin/fragment/notes/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end

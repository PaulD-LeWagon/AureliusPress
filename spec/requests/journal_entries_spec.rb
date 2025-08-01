require 'rails_helper'

RSpec.describe "JournalEntries", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/journal_entries/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/journal_entries/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/journal_entries/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/journal_entries/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/journal_entries/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/journal_entries/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/journal_entries/delete"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /custom" do
    it "returns http success" do
      get "/journal_entries/custom"
      expect(response).to have_http_status(:success)
    end
  end

end

require "rails_helper"

RSpec.describe "AureliusPress::Api::V1::Catalogue::Quotes", type: :request do
  let!(:source) { create(:aurelius_press_catalogue_source, title: "Meditations") }
  let!(:quote_a) { create(:aurelius_press_catalogue_quote, text: "The soul is dyed by the color of its thoughts.", source: source) }
  let!(:quote_b) { create(:aurelius_press_catalogue_quote, text: "Waste no more time arguing what a good man should be. Be one.", source: source) }

  describe "GET /aurelius-press/api/v1/catalogue/quotes" do
    it "returns a paginated list of all quotes without authentication" do
      get "/aurelius-press/api/v1/catalogue/quotes", as: :json
      
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.length).to eq(2)
      
      # Check for nested data
      first_quote = json_response.first
      expect(first_quote).to have_key("text")
      expect(first_quote["source"]).to have_key("title")
      expect(first_quote["source"]["title"]).to eq("Meditations")
    end
  end

  describe "GET /aurelius-press/api/v1/catalogue/quotes/:slug" do
    it "returns a single quote by slug" do
      get "/aurelius-press/api/v1/catalogue/quotes/#{quote_a.slug}", as: :json
      
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response["text"]).to eq(quote_a.text)
    end

    it "returns 404 for non-existent quote" do
      get "/aurelius-press/api/v1/catalogue/quotes/non-existent", as: :json
      expect(response).to have_http_status(:not_found)
    end
  end
end

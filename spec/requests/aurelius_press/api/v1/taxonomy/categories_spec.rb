require "rails_helper"

RSpec.describe "AureliusPress::Api::V1::Taxonomy::Categories", type: :request do
  let!(:admin) { create(:aurelius_press_user, :admin) }
  let!(:cat_stoic) { create(:aurelius_press_taxonomy_category, name: "Stoic Philosophy") }
  let!(:cat_logic) { create(:aurelius_press_taxonomy_category, name: "Logic") }

  describe "GET /aurelius-press/api/v1/taxonomy/categories" do
    context "when authenticated as admin" do
      before do
        sign_in admin
      end

      it "returns a list of categories matching the query" do
        get "/aurelius-press/api/v1/taxonomy/categories", params: { q: "stoi" }, as: :json
        
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.map { |c| c["name"] }).to include("Stoic Philosophy")
      end

      it "returns an empty array when no matches are found" do
        get "/aurelius-press/api/v1/taxonomy/categories", params: { q: "nomatch" }, as: :json
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when unauthenticated" do
      before do
        sign_out :user
      end

      it "returns unauthorized" do
        get "/aurelius-press/api/v1/taxonomy/categories", params: { q: "stoi" }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

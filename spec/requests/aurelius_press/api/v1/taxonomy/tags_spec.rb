require "rails_helper"

RSpec.describe "AureliusPress::Api::V1::Taxonomy::Tags", type: :request do
  let!(:admin) { create(:aurelius_press_user, :admin) }
  let!(:tag_stoicism) { create(:aurelius_press_taxonomy_tag, name: "Stoicism") }
  let!(:tag_ethics) { create(:aurelius_press_taxonomy_tag, name: "Ethics") }

  describe "GET /aurelius-press/api/v1/taxonomy/tags" do
    context "when authenticated as admin" do
      before do
        sign_in admin
      end

      it "returns a list of tags matching the query" do
        get "/aurelius-press/api/v1/taxonomy/tags", params: { q: "stoi" }, as: :json
        
        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.first["name"]).to eq("Stoicism")
      end

      it "returns an empty array when no matches are found" do
        get "/aurelius-press/api/v1/taxonomy/tags", params: { q: "nomatch" }, as: :json
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        get "/aurelius-press/api/v1/taxonomy/tags", params: { q: "stoi" }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

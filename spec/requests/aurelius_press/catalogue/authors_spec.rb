require 'rails_helper'

RSpec.describe "AureliusPress::Catalogue::Authors", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/catalogue/authors/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/catalogue/authors/show"
      expect(response).to have_http_status(:success)
    end
  end

end

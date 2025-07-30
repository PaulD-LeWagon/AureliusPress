require 'rails_helper'

RSpec.describe "AureliusPress::Catalogue::Quotes", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/catalogue/quotes/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/catalogue/quotes/show"
      expect(response).to have_http_status(:success)
    end
  end

end

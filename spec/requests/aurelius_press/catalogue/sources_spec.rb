require 'rails_helper'

RSpec.describe "AureliusPress::Catalogue::Sources", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/aurelius_press/catalogue/sources/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius_press/catalogue/sources/show"
      expect(response).to have_http_status(:success)
    end
  end

end

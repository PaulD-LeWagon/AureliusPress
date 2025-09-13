require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "home landing page" do
    it "GET / returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
    it "GET /home returns http success" do
      get "/home"
      expect(response).to have_http_status(:success)
    end
  end
end

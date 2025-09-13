require 'rails_helper'

RSpec.describe "AureliusPress::Admin::Community::Groups", type: :request, skip: true do
  before do
    # Create and sign in the user once for all tests.
    sign_in create(:aurelius_press_admin_user)
  end

  describe "GET /index" do
    it "returns http success" do
      get "/aurelius-press/admin/community/groups/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/aurelius-press/admin/community/groups/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/aurelius-press/admin/community/groups/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/aurelius-press/admin/community/groups/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/aurelius-press/admin/community/groups/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/aurelius-press/admin/community/groups/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/aurelius-press/admin/community/groups/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
